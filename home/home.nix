{ config, pkgs, lib, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;
  home.username = "vinay";
  home.homeDirectory = "/home/vinay";

  home.stateVersion = "22.11";
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "${config.home.homeDirectory}";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/temp";
    };
    configFile = {
      nvim = {
        source = ./nvim;
        recursive = true;
      };
      "offlineimap/config".source = ./offlineimaprc;
      "i3/config".source = ./i3_config;
      i3status.source = ./i3status;
      "neomutt/neomuttrc".source = ./neomuttrc;
      "spotifyd/spotifyd.conf".source = ./spotifyd.conf;
      "spotify-tui/config.yml".source = ./spotify-tui.yml;
      "wezterm/wezterm.lua".source = ./wezterm.lua;
      screenlayout.source = ./screenlayout;
      openrazer = {
        source = ./openrazer;
        recursive = true;
      };
      "starship.toml".source = ./starship.toml;
    };
    mimeApps = {
      enable = true;
      associations.added = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "text/plain" = [ "nvim.desktop" ];
      };
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "text/plain" = [ "nvim.desktop" ];
        "text/html" = [ "firefox.desktop" ];
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 7200;
    defaultCacheTtlSsh = 1800;
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

  home.packages = with pkgs; [
    appimage-run
    arandr
    bat
    btop
    calibre
    cudaPackages.cudatoolkit
    difftastic
    du-dust
    entr
    exa
    fd
    fd
    firefox
    flameshot
    fzf
    gcalcli
    gimp
    git
    gnumake
    go
    gparted
    htop
    hyperfine
    kitty
    lazygit
    libreoffice
    neofetch
    neomutt
    nil
    nodejs-16_x
    obsidian
    openssl
    pamixer
    pandoc
    prusa-slicer
    sd
    teamviewer
    tokei
    zoom-us
    (pass.withExtensions (ext: with ext;
    [
      pass-otp
    ]))
    pasystray
    python310
    python310Packages.python-lsp-server
    python310Packages.virtualenvwrapper
    ripgrep
    spotify-tui
    spotifyd
    sshfs
    texlive.combined.scheme-full
    unzip
    vlc
    xclip

    # PDF viewers
    evince
    zathura


    # Rustdev
    gcc
    llvmPackages_latest.libclang
    # llvmPackages_latest.bintools
    # llvmPackages_latest.lld
    rustup
    rust-analyzer
    pkg-config
    poetry
    graphviz

    # tasks
    taskwarrior
    taskwarrior-tui
  ] ++
  [
    pkgsUnstable.neovim
    pkgsUnstable.wezterm
    pkgsUnstable.starship
  ]
  ;


  programs = {
    home-manager.enable = true;
    offlineimap.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      cd = "cl";
      clear = "printf '\n%.0s' {1..100}";
      lg = "lazygit";
      ll = "exa -la";
      ls = "exa";
      o = "xdg-open $@";
      open = "cd ~; xdg-open $(fzf)";
      tree = "exa --tree";
    };
    sessionVariables = {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      PATH = "$PATH:/home/vinay/src/bin";
    };
    initExtraFirst = ''printf '\n%.0s' {1..100};'';
    initExtra = ''
      cl() { z "$@" && exa -a; };
      eval "$(starship init zsh)"
    '';
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    zplug = {
      zplugHome = "${config.xdg.configHome}/zsh/zplug";
      enable = true;
      plugins = [
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "catppuccin/zsh-syntax-highlighting"; }
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Vinay Mehta";
    userEmail = "vinaymehta.nyc@gmail.com";
    signing = {
      key = "7BFD93BA3C710416";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      diff.tool = "vimdiff";
      merge.tool = "vimdiff";
      difftool.prompt = false;
    };
  };

  services.spotifyd = {
    enable = true;
  };




  #  programs.firefox.profiles.default = {
  #    isDefault = true;
  #    settings = {
  #      "toolkit.legacyuserProfileCustomizations.stylesheets" = true;
  #      "signon.rememberSignons" = false;
  #    };
  #    userChrome = builtins.readFile ./userChrome.css;
  #  };


}
