{
  description = "Neovim";

  inputs = {
    nixpkgs.url = "nixpkgs"; # I pin nixpkgs on my systems, so this gets updated to match that
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # plugins
    "plugin:vim-repeat" = { url = "github:tpope/vim-repeat"; flake = false; };
    "plugin:plenary.nvim" = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    "plugin:nvim-lspconfig" = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    "plugin:lsp_signature.nvim" = { url = "github:ray-x/lsp_signature.nvim"; flake = false; };
    "plugin:nvim-lightbulb" = { url = "github:kosayoda/nvim-lightbulb"; flake = false; };
    "plugin:nvim-cmp" = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    "plugin:cmp-nvim-lsp" = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
    "plugin:cmp-buffer" = { url = "github:hrsh7th/cmp-buffer"; flake = false; };
    "plugin:cmp-path" = { url = "github:hrsh7th/cmp-path"; flake = false; };
    "plugin:cmp-cmdline" = { url = "github:hrsh7th/cmp-cmdline"; flake = false; };
    "plugin:LuaSnip" = { url = "github:L3MON4D3/LuaSnip"; flake = false; };
    "plugin:cmp_luasnip" = { url = "github:saadparwaiz1/cmp_luasnip"; flake = false; };
    "plugin:goyo.vim" = { url = "github:junegunn/goyo.vim"; flake = false; };
    "plugin:undotree" = { url = "github:mbbill/undotree"; flake = false; };
    "plugin:telescope.nvim" = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    "plugin:vim-eunuch" = { url = "github:tpope/vim-eunuch"; flake = false; };
    "plugin:vim-recover" = { url = "github:ralismark/vim-recover"; flake = false; };
    "plugin:Colorizer" = { url = "github:chrisbra/Colorizer"; flake = false; };
    "plugin:guess-indent.nvim" = { url = "github:NMAC427/guess-indent.nvim"; flake = false; };
    # "plugin:vim-pandoc-syntax" = { url = "github:vim-pandoc/vim-pandoc-syntax"; flake = false; };
    #"plugin:vim-polyglot" = { url = "github:sheerun/vim-polyglot"; flake = false; };
    "plugin:vim-easy-align" = { url = "github:junegunn/vim-easy-align"; flake = false; };
    "plugin:vim-textobj-user" = { url = "github:kana/vim-textobj-user"; flake = false; };
    "plugin:vim-textobj-indent" = { url = "github:kana/vim-textobj-indent"; flake = false; };
    "plugin:vim-textobj-parameter" = { url = "github:sgur/vim-textobj-parameter"; flake = false; };
    "plugin:vim-textobj-between" = { url = "github:thinca/vim-textobj-between"; flake = false; };
    "plugin:opsort.vim" = { url = "github:ralismark/opsort.vim"; flake = false; };
    "plugin:vim-nix" = { url = "github:LnL7/vim-nix"; flake = false; };
    "plugin:rainbow-delimiters.nvim" = { url = "github:hiphish/rainbow-delimiters.nvim"; flake = false; };
    "plugin:indent-blankline.nvim" = { url = "github:lukas-reineke/indent-blankline.nvim"; flake = false; };
    "plugin:base16-nvim" = { url = "github:RRethy/base16-nvim"; flake = false; };

    # plugins with custom steps
    "telescope-fzf-native.nvim" = { url = "github:nvim-telescope/telescope-fzf-native.nvim"; flake = false; };
    "sg.nvim" = { url = "github:sourcegraph/sg.nvim"; flake = false; }; # no flake; they pull in too many dependencies
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;

        # parse inputs to extract everything beginning with plugin:
        autoPlugins = let
          buildPlug = name: src: pkgs.vimUtils.buildVimPlugin {
            pname = lib.removePrefix "plugin:" name;
            version = src.shortRev;
            inherit src;
          };
        in
          lib.mapAttrsToList buildPlug
            (lib.filterAttrs (k: _: lib.hasPrefix "plugin:" k) inputs);

        # full list of plugins
        plugins = [
          (pkgs.vimUtils.buildVimPlugin rec {
            pname = "telescope-fzf-native.nvim";
            src = inputs."${pname}";
            version = src.shortRev;

            buildPhase = ''
              make
            '';
          })
        ] ++ autoPlugins;

        # create a neovim package with a given RC
        neovim-with-rc = customRC: pkgs.wrapNeovim pkgs.neovim-unwrapped {
          withRuby = false;
          withPython3 = false;
          configure = {
            inherit customRC;
            packages.main = {
              start = plugins ++ [
                pkgs.vimPlugins.nvim-treesitter.withAllGrammars
              ];
            };
          };
        };

        # wrap neovim+vimrc in a script that runs nvr/nvim as appropriate
        with-extra-scripts = final-neovim:
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
              # unescape MAN_PN -- see <https://gitlab.com/man-db/man-db/-/blob/92dd5e7fb57fd841b89e21bf16b584aa654c612b/src/man.c#L870-898>
              pn=$(printf %s "$MAN_PN" | sed -e 's/\\\(.\)/\1/g')
              if [ -n "$NVIM" ]; then
                echo "Opening man page for '$pn' in parent vim..."
                exec ${pkgs.neovim-remote}/bin/nvr --nostart -c "Man $pn"
              else
                exec ${final-neovim}/bin/nvim "man://$pn"
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
          let g:flake_lock = "${./.}/flake.lock"

          let $PATH .= ":${pkgs.ripgrep}/bin:${pkgs.nodejs}/bin"
        '';
      in
      rec {
        apps.default = apps.hosted;
        packages.default = packages.hosted;

        apps.hosted = {
          type = "app";
          program = "${packages.hosted}/bin/vim";
        };
        packages.hosted = with-extra-scripts (neovim-with-rc ''
          ${common-rc}

          " hosted: bootstrap into actual vimrc
          let &rtp = stdpath("config") .. "," .. &rtp .. "," .. stdpath("config") .. "/after"
          let $MYVIMRC = stdpath("config") .. "/init.lua"
          source $MYVIMRC
        '');

        apps.freestanding = {
          type = "app";
          program = "${packages.freestanding}/bin/nvim";
        };
        # we need to use ${./.} here instead of e.g. ${./init.lua} to ensure
        # the whole directory is copied over
        packages.freestanding = neovim-with-rc ''
          ${common-rc}

          " freestanding: bootstrap into packaged vimrc
          let g:freestanding = 1
          let &rtp = "${./.}," .. &rtp .. ",${./.}/after"
          let $MYVIMRC = "${./.}/init.lua"
          source $MYVIMRC
        '';

        # ---------------------------------------------------------------------


      });
}
