{ config, pkgs, ... }:

{

  nixpkgs.config.allowUnfree = true;
  home.username = "vinay";
  home.homeDirectory = "/home/vinay";

  home.stateVersion = "22.11";
  xdg.enable = true;

  home.packages = with pkgs; [
    obsidian
    git
    gnumake
    kitty
    nil
    openssl
    (pass.withExtensions (ext: with ext;
    [
      pass-otp
    ]))
    python310
    python310Packages.pip
    python310Packages.python-lsp-server
    spotify-tui
    btop
    calibre
    firefox
    htop
    offlineimap
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
      gitsigns-nvim
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
      # which-key-nvim

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

      # Snippets
      luasnip
      cmp_luasnip

    ];
    extraPackages = with pkgs; [
      black
      fd
      nixpkgs-fmt
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

  xdg.configFile."kitty/kitty.conf" = {
    source = ./kitty.conf;
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
  xdg.configFile."offlineimap/config" = {
    source = ./offlineimaprc;
  };

  xdg.configFile."i3/config" = {
    source = ./i3_config;
  };

  xdg.configFile.i3status = {
    source = ./i3status;
    recursive = true;
  };
  xdg.configFile."spotifyd/spotifyd.conf" = {
    source = ./spotifyd.conf;
  };
  xdg.configFile."spotify-tui/config.yml" = {
    source = ./spotify-tui.yml;
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
