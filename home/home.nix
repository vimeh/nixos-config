{ config, pkgs, lib, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> { };
  fromGitHub = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };

  tmux-sessionizer = pkgs.writeShellScriptBin "tmux-sessionizer" ''
    # https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer

    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(fd . /home/vinay/code --min-depth 1 --max-depth 1 -t d | fzf | sed 's:/*$::')
    fi

    if [[ -z $selected ]]; then
        exit 0
    fi

    selected_name=$(basename "$selected" | tr . _)
    tmux_running=$(pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s $selected_name -c $selected
        exit 0
    fi

    if ! tmux has-session -t=$selected_name 2> /dev/null; then
        tmux new-session -ds $selected_name -c $selected
    fi

    tmux switch-client -t $selected_name
  '';
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
      screenlayout.source = ./screenlayout;
      openrazer = {
        source = ./openrazer;
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
    entr
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
    pandoc
    texlive.combined.scheme-full
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
    sshfs
    tmux-sessionizer
    unzip
    xclip

    # PDF viewers; TODO choose one?
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

    # tasks
    taskwarrior
    taskwarrior-tui
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
      ts = "tmux-sessionizer";
    };
    sessionVariables = {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };
    initExtraFirst = ''printf '\n%.0s' {1..100};'';
    initExtra = ''cl() { z "$@" && exa -a; };
                  if [ "$TMUX" = "" ]; then tmux; fi;
                '' + builtins.readFile ./p10k.zsh;
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
    escapeTime = 0;
    secureSocket = false;
    terminal = "tmux-256color";
    extraConfig = ''
      # extend vim-tmux-navigator for pane resizing
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
      bind-key -n C-S-h if-shell "$is_vim" 'send-keys C-S-h' 'resize-pane -L 3'
      bind-key -n C-S-j if-shell "$is_vim" 'send-keys C-S-j' 'resize-pane -D 3'
      bind-key -n C-S-k if-shell "$is_vim" 'send-keys C-S-k' 'resize-pane -U 3'
      bind-key -n C-S-l if-shell "$is_vim" 'send-keys C-S-l' 'resize-pane -R 3'
      bind-key -T copy-mode-vi 'C-S-h' resize-pane -L 3  
      bind-key -T copy-mode-vi 'C-S-j' resize-pane -D 3
      bind-key -T copy-mode-vi 'C-S-k' resize-pane -U 3
      bind-key -T copy-mode-vi 'C-S-l' resize-pane -R 3

      # some QoL
      set-option -g allow-rename off
      set -g mouse on
      bind r source-file ~/.config/tmux/tmux.conf
      bind-key -n M-S split-window -v
      bind-key -n M-s split-window -h
    '';
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
      tmux-fzf
      prefix-highlight
      yank
      nord
      vim-tmux-navigator
    ];
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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      # plugins set up in nvim/
      # color.lua
      catppuccin-nvim
      lualine-nvim
      twilight-nvim

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

      # navigation
      (fromGitHub "HEAD" "mrjones2014/smart-splits.nvim")

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
      {
        plugin = toggleterm-nvim;
        type = "lua";
        config = "require('toggleterm').setup()";
      }
      {
        plugin = (fromGitHub "HEAD" "folke/persistence.nvim");
        type = "lua";
        config = "require('persistence').setup()";
      }
      lazygit-nvim
      markdown-preview-nvim
      nvim-web-devicons
      (fromGitHub "HEAD" "shortcuts/no-neck-pain.nvim")
      zen-mode-nvim

    ] ++ [
      pkgsUnstable.vimPlugins.copilot-lua
      pkgsUnstable.vimPlugins.copilot-cmp
      pkgsUnstable.vimPlugins.winshift-nvim
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
