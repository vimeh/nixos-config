{ config, pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{

  nixpkgs.config.allowUnfree = true;
  home.username = "vinay";
  home.homeDirectory = "/home/vinay";

  home.stateVersion = "22.11";
  xdg.enable = true;

  home.packages = with pkgs; [
    btop
    calibre
    firefox
    git
    gnumake
    htop
    kitty
    neomutt
    nil
    nodejs-16_x
    obsidian
    openssl
    (pass.withExtensions (ext: with ext;
    [
      pass-otp
    ]))
    pasystray
    python310
    python310Packages.pip
    python310Packages.python-lsp-server
    spotify-tui
    spotifyd
    tmux
  ];

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-completions"; }
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
      catppuccin-nvim
      comment-nvim
      feline-nvim
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = "require('gitsigns').setup({
           sign_priority = 0,
         })
         ";
      }
      harpoon
      leap-nvim
      legendary-nvim
      neo-tree-nvim
      nvim-autopairs
      nvim-lspconfig
      nvim-notify
      nvim-treesitter-refactor
      nvim-treesitter-textobjects
      nvim-treesitter.withAllGrammars
      telescope-nvim
      vim-smoothie
      vim-surround
      which-key-nvim

      # Highlight selected symbol
      vim-illuminate

      # Completions
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-path
      lspkind-nvim
      nvim-cmp
      cmp-copilot

      # Snippets
      luasnip
      cmp_luasnip

      # formatter
      neoformat

    ] ++ [ pkgsUnstable.vimPlugins.copilot-lua ];
    extraPackages = with pkgs; [
      black
      fd
      nixpkgs-fmt
      stylua
      pyright
      ripgrep
      rnix-lsp
      sumneko-lua-language-server
      tree-sitter
    ];
    extraConfig = ''
      :luafile ~/.config/nvim/lua/init.lua
    '';
  };

  programs.offlineimap = {
    enable = true;
  };



  xdg.configFile = {
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
