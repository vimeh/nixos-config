{ config, pkgs, lib, callPackage, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      <home-manager/nixos>
    ];

  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # hardware
  hardware.openrazer = {
    enable = true;
  };

  # for i3
  environment.pathsToLink = [ "/libexec" ];

  # Nvidia stuff
  boot.kernelParams = [ "button.lid_init_state=open" ];

  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  hardware.nvidia = {
    powerManagement.enable = true;
    modesetting.enable = true;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  services.udev.packages = [
  (pkgs.writeTextFile {
      name = "nsusbloader_rcm";
      text = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0955", ATTRS{idProduct}=="7321", MODE="0666"
      '';
      destination = "/etc/udev/rules.d/99-NS-RCM.rules";
    }
  )
  ];



  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-42359df3-4249-4611-a212-26f9c3178af1".device = "/dev/disk/by-uuid/42359df3-4249-4611-a212-26f9c3178af1";
  boot.initrd.luks.devices."luks-42359df3-4249-4611-a212-26f9c3178af1".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "tb"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  security.auditd.enable = true;
  security.audit.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    videoDrivers = [ "nvidia" ];
    desktopManager = {
      xterm.enable = false;
    };

    # needed explicitly for i3 as a display manager
    libinput.enable = true;

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
      sessionCommands = "setxkbmap -option caps:escape";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };

  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser pkgs.gutenprint pkgs.gutenprintBin ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.vinay = {
    isNormalUser = true;
    description = "vinay";
    extraGroups = [ "video" "networkmanager" "wheel" "docker" "openrazer" "audio" "plugdev" ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "vinay";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    appimage-run
    clipmenu
    gnupg
    pamixer
    pinentry-curses
    teamviewer
    vim_configurable
    volctl
    wget
    xorg.xev
    v4l-utils
    libv4l
  ];
  environment.shells = with pkgs; [ zsh ];
  environment.variables.EDITOR = "nvim";

  programs = {
    nm-applet.enable = true;
    ssh.startAgent = true;
    zsh.enable = true;
  };

  programs.gnupg = {
    agent = {
      enable = true;
      enableExtraSocket = true;
      pinentryFlavor = "curses";
    };
  };

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services = {
    openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
      passwordAuthentication = false;
      # allowSFTP = false;
    };
    fail2ban = {
      enable = true;
      ignoreIP = [ ];
    };
    teamviewer.enable = true;
  };

  system.stateVersion = "22.11";

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # light media keys
  programs.light.enable = true;

  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [ "Iosevka" ];
      })
      (iosevka-bin.override {
        variant = "etoile";
      })
    ];
  };

  services.borgbackup.jobs =
    let
      common-excludes = [
        "code/nixpkgs"
        "code/openai-whisper-realtime"
        ".cache"
        ".rustup"
        ".local/share/Steam"
        "code/*/target"
        "mnt"
      ];
      basicBackup = name: {
        paths = [ "/home" ];
        environment.BORG_RSH = "ssh -i /root/borgbackup/ssh_key";
        compression = "auto,lzma";
        startAt = "daily";
        exclude = map (x: "/home/*/" + x) common-excludes;
      };
    in
    {
      kipling = basicBackup "kipling" // rec {
        repo = "pi@nas.local:/tank/media/backups/tb";
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat /root/borgbackup/passphrase";
        };
      };
      rsync-net = basicBackup "rsync" // rec {
        repo = "de2494@de2494.rsync.net:borg_tb";
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat /root/borgbackup_rsync.net/passphrase";
        };
        extraArgs = "--remote-path=borg1";
      };
    };

  /* networking.wg-quick.interfaces = {
        wg0 = {
      configFile = builtins.readFile ./wg0.conf;
        };
      }; */


}
