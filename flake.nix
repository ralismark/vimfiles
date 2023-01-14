{
  description = "Neovim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    neovim = {
      url = "github:neovim/neovim?dir=contrib&ref=v0.7.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # plugins
    "plugin:vim-repeat" = { url = "github:tpope/vim-repeat"; flake = false; };
    "plugin:plenary.nvim" = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    "plugin:nvim-lspconfig" = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    "plugin:null-ls.nvim" = { url = "github:jose-elias-alvarez/null-ls.nvim"; flake = false; };
    "plugin:lsp_signature.nvim" = { url = "github:ray-x/lsp_signature.nvim"; flake = false; };
    "plugin:nvim-lightbulb" = { url = "github:kosayoda/nvim-lightbulb"; flake = false; };
    "plugin:nvim-cmp" = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    "plugin:cmp-nvim-lsp" = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
    "plugin:cmp-buffer" = { url = "github:hrsh7th/cmp-buffer"; flake = false; };
    "plugin:cmp-path" = { url = "github:hrsh7th/cmp-path"; flake = false; };
    "plugin:cmp-cmdline" = { url = "github:hrsh7th/cmp-cmdline"; flake = false; };
    "plugin:LuaSnip" = { url = "github:L3MON4D3/LuaSnip"; flake = false; };
    "plugin:cmp_luasnip" = { url = "github:saadparwaiz1/cmp_luasnip"; flake = false; };
    "plugin:ayu-vim" = { url = "github:ayu-theme/ayu-vim"; flake = false; };
    "plugin:goyo.vim" = { url = "github:junegunn/goyo.vim"; flake = false; };
    "plugin:undotree" = { url = "github:mbbill/undotree"; flake = false; };
    # "plugin:rainbow" = { url = "github:luochen1990/rainbow"; flake = false; };
    "plugin:telescope.nvim" = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    "plugin:vim-dispatch" = { url = "github:tpope/vim-dispatch"; flake = false; };
    "plugin:vim-eunuch" = { url = "github:tpope/vim-eunuch"; flake = false; };
    "plugin:vim-recover" = { url = "github:ralismark/vim-recover"; flake = false; };
    "plugin:Colorizer" = { url = "github:chrisbra/Colorizer"; flake = false; };
    "plugin:guess-indent.nvim" = { url = "github:NMAC427/guess-indent.nvim"; flake = false; };
    "plugin:editorconfig-vim" = { url = "github:editorconfig/editorconfig-vim"; flake = false; };
    "plugin:vim-pandoc-syntax" = { url = "github:vim-pandoc/vim-pandoc-syntax"; flake = false; };
    "plugin:vim-polyglot" = { url = "github:sheerun/vim-polyglot"; flake = false; };
    "plugin:vim-easy-align" = { url = "github:junegunn/vim-easy-align"; flake = false; };
    "plugin:vim-textobj-user" = { url = "github:kana/vim-textobj-user"; flake = false; };
    "plugin:vim-textobj-indent" = { url = "github:kana/vim-textobj-indent"; flake = false; };
    "plugin:vim-textobj-parameter" = { url = "github:sgur/vim-textobj-parameter"; flake = false; };
    "plugin:vim-textobj-between" = { url = "github:thinca/vim-textobj-between"; flake = false; };
    "plugin:tcomment_vim" = { url = "github:tomtom/tcomment_vim"; flake = false; };
    "plugin:opsort.vim" = { url = "github:ralismark/opsort.vim"; flake = false; };
    "plugin:vim-replacewithregister" = { url = "github:inkarkat/vim-ReplaceWithRegister"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, neovim, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        neovim-unwrapped = neovim.packages.${system}.neovim;

        # other binaries to make accessible to vim
        extraEnv = pkgs.symlinkJoin {
          name = "vim-bundled";
          paths = [
          ];
        };

        # parse inputs to extract everything beginning with plugin:
        vimPlugins =
          let
            plugName = input:
              builtins.substring
                (builtins.stringLength "plugin:")
                (builtins.stringLength input)
                input;

            buildPlug = name: pkgs.vimUtils.buildVimPluginFrom2Nix {
              pname = plugName name;
              version = "master";
              src = builtins.getAttr name inputs;
            };
          in
          builtins.map buildPlug
            (builtins.attrNames
              (pkgs.lib.attrsets.filterAttrs
                (k: v: (builtins.match "plugin:.*" k) != null)
                inputs));

        neovim-with-bootstrapper = customRC: pkgs.wrapNeovim neovim-unwrapped {
          withRuby = false;
          withPython3 = false;
          configure = {
            inherit customRC;
            packages.main = {
              start = vimPlugins;
            };
          };
        };

        # wrap neovim+vimrc in a script that runs nvr/nvim as appropriate
        with-nvim = final-neovim:
          let
            # The dependency on neovim-remote is mainly because --remote-wait is unsupported
            vim = pkgs.writeScriptBin "vim" ''
              if [ -n "$NVIM" ]; then
                if [ "$#" -eq 0 ]; then
                  echo "Can't open blank nested neovim" >&2
                  exit 1
                else
                  exec ${pkgs.neovim-remote}/bin/nvr --nostart -cc split -c "setl bufhidden=delete" --remote-wait "$@"
                fi
              else
                exec ${final-neovim}/bin/nvim "$@"
              fi
            '';

            manpager = pkgs.writeScriptBin "vim-manpager" ''
              cat > /dev/null # eat the rendered page
              if [ -n "$NVIM" ]; then
                echo "Opening man page for '$MAN_PN' in parent vim..."
                exec ${pkgs.neovim-remote}/bin/nvr --nostart -c "Man $MAN_PN"
              else
                exec ${final-neovim}/bin/nvim "man://$MAN_PN"
              fi
            '';
          in
          pkgs.symlinkJoin {
            name = "neovim";
            paths = [ final-neovim vim manpager ];
          };

        # common bits of rc init
        common-rc = ''
          " shared init
          let $PATH .= ":${extraEnv}/bin"
          let g:flake_lock = "${./.}/flake.lock"
        '';
      in
      rec {
        packages.unwrapped = neovim-unwrapped;

        apps.default = apps.hosted;
        packages.default = packages.hosted;

        apps.hosted = {
          type = "app";
          program = "${packages.hosted}/bin/vim";
        };
        packages.hosted = with-nvim (neovim-with-bootstrapper ''
          ${common-rc}

          " hosted: bootstrap into actual vimrc
          let &rtp = stdpath("config") .. "," .. &rtp .. "," .. stdpath("config") .. "/after"
          let $MYVIMRC = stdpath("config") .. "/init.vim"
          source $MYVIMRC
        '');

        apps.freestanding = {
          type = "app";
          program = "${packages.freestanding}/bin/nvim";
        };
        # we need to use ${./.} here instead of e.g. ${./init.vim} to ensure
        # the whole directory is copied over
        packages.freestanding = neovim-with-bootstrapper ''
          ${common-rc}

          " freestanding: bootstrap into packaged vimrc
          let g:freestanding = 1
          let &rtp = "${./.}," .. &rtp .. ",${./.}/after"
          let $MYVIMRC = "${./.}/init.vim"
          source $MYVIMRC
        '';
      });
}
