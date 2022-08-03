{
  description = "Neovim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    neovim = {
      url = "github:neovim/neovim?dir=contrib&ref=v0.7.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, neovim, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        neovim-underlying = neovim.packages.${system}.neovim;
      in
      rec {
        apps.default = apps.remote-wrapper;
        packages.default = packages.remote-wrapper;

        apps.remote-wrapper = {
          type = "app";
          program = "${packages.remote-wrapper}/bin/vim";
        };

        # The dependency on neovim-remote is mainly because --remote-wait is unsupported
        packages.remote-wrapper = pkgs.writeScriptBin "vim" ''
          if [ -n "$NVIM" ]; then
            if [ "$#" -eq 0 ]; then
              echo "Can't open blank nested neovim" >&2
              exit 1
            else
              exec ${pkgs.neovim-remote}/bin/nvr --nostart -cc split -c "setl bufhidden=delete" --remote-wait "$@"
            fi
          else
            exec ${packages.my-neovim}/bin/nvim "$@"
          fi
        '';

        packages.my-neovim = pkgs.wrapNeovim neovim-underlying {
          withRuby = false;
          configure = {
            customRC = ''
              " for now, bootstrap into actual vimrc
              let &rtp .= "," .. stdpath("config")
              let $MYVIMRC = stdpath("config") .. "/init.vim"
              source $MYVIMRC
            '';
          };
        };
      });
}
