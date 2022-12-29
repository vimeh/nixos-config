{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "vinay";
  home.homeDirectory = "/home/vinay";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  home.packages = [
    pkgs.btop
    pkgs.htop
  ];


  # Let Home Manager install and manage itself.
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
      telescope-nvim
      vim-smoothie
      vim-surround

        # Highlight selected symbol
        vim-illuminate

        # Completions
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp-nvim-lsp-signature-help
        nvim-cmp
        lspkind-nvim

        # Snippets
        luasnip
        cmp_luasnip

    ];
      extraPackages = with pkgs; [
        tree-sitter
        sumneko-lua-language-server
        rnix-lsp
        nixpkgs-fmt
        pyright
        black
        ripgrep
        fd
      ];
	  extraConfig = ''
	  :luafile ~/.config/nvim/lua/init.lua
	  '';
  };


  xdg.configFile.nvim = {
      source = ./config;
      recursive = true;
  };

}
