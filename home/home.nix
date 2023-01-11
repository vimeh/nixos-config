{ config, pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{

  nixpkgs.config.allowUnfree = true;
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
      "kitty/kitty.conf".source = ./kitty.conf;
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
      screenlayout = {
        source = ./screenlayout;
        recursive = true;
      };
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
    teamviewer
    arandr
    btop
    calibre
    difftastic
    exa
    firefox
    fd
    fzf
    flameshot
    git
    gnumake
    htop
    kitty
    lazygit
    neomutt
    nil
    nodejs-16_x
    obsidian
    openssl
    pamixer
    (pass.withExtensions (ext: with ext;
    [
      pass-otp
    ]))
    pasystray
    python310
    python310Packages.pip
    python310Packages.python-lsp-server
    ripgrep
    spotify-tui
    spotifyd
    tmux

    # PDF viewers; TODO choose one?
    evince
    zathura


    # Rustdev
    gcc
    # llvmPackages_latest.libclang
    # llvmPackages_latest.bintools
    # llvmPackages_latest.lld
    rustup
    rust-analyzer
    pkg-config
  ];


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
    };
    initExtraFirst = ''printf '\n%.0s' {1..100};'';
    initExtra = ''cl() { z "$@" && exa -a; };'' + builtins.readFile ./p10k.zsh;
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
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    newSession = true;
    # escapeTime = 0;
    secureSocket = false;
    extraConfig = ''
      bind-key -n M-s split-window -v
      bind-key -n M-S split-window -h

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-k select-pane -U
      bind-key -n M-l select-pane -R
    '';
  };

  programs.git = {
    enable = true;
    userName = "Vinay Mehta";
    userEmail = "vinaymehta.nyc@gmail.com";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      # plugins set up in nvim/
      # color.lua
      catppuccin-nvim
      feline-nvim

      # telescope.lua
      telescope-nvim
      harpoon

      # lsp.lua
      nvim-lspconfig
      nvim-treesitter-refactor
      nvim-treesitter-textobjects
      nvim-treesitter.withAllGrammars
      # Completions
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-path
      lspkind-nvim
      nvim-cmp
      # Snippets
      luasnip
      cmp_luasnip

      # formatter.lua
      neoformat

      # filetree viewer
      neo-tree-nvim

      # plugins set up here
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = "require('gitsigns').setup({
      sign_priority = 0,
      })
      ";
      }
      {
        plugin = which-key-nvim;
        type = "lua";
        config = "require('which-key').setup()";
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = "require('nvim-autopairs').setup()";
      }
      {
        plugin = nvim-surround;
        type = "lua";
        config = "require('nvim-surround').setup()";
      }
      {
        plugin = comment-nvim;
        type = "lua";
        config = "require('Comment').setup()";
      }
      {
        plugin = leap-nvim;
        type = "lua";
        config = "require('leap').add_default_mappings()";
      }
      {
        plugin = fidget-nvim;
        type = "lua";
        config = "require('fidget').setup()";
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = "require('indent_blankline').setup({
      show_current_context = true,
      show_current_context_start = true,
      })";
      }
      {
        plugin = nvim-lastplace;
        type = "lua";
        config = "require('nvim-lastplace').setup()";
      }
      {
        plugin = trouble-nvim;
        type = "lua";
        config = "require('trouble').setup()";
      }
      lazygit-nvim
      markdown-preview-nvim
      nvim-web-devicons

    ] ++ [
      pkgsUnstable.vimPlugins.copilot-lua
      pkgsUnstable.vimPlugins.copilot-cmp
    ];
    extraPackages = with pkgs; [
      black
      nixpkgs-fmt
      nodePackages.bash-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      pyright
      rnix-lsp
      sumneko-lua-language-server
      tree-sitter
    ];
    extraConfig = ''
      :luafile ~/.config/nvim/lua/init.lua
    '';
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
