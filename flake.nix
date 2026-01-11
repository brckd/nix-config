{
  description = "NixOS configuration";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({
      lib,
      self,
      ...
    }: let
      inherit (tree) paths evalAll modules;

      systems = import inputs.systems;
      tree = import ./lib/tree/default.nix {
        inherit lib self inputs systems;
      };
    in {
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks.flakeModule
      ];

      inherit systems;

      flake = {
        inherit (modules.generic) lib templates;
        homeModules = modules.mixed.modules.home;
        nixosModules = paths.mixed.modules.nixos;
      };

      perSystem = {
        config,
        options,
        pkgs,
        system,
        ...
      }: let
        specialArgs.generic' = tree.specialArgs.generic // {inherit config options pkgs system;};
        modules.generic' = evalAll.generic specialArgs.generic' paths.generic;
      in {
        inherit (modules.generic') checks apps packages legacyPackages devShells;

        treefmt.config = {
          projectRootFile = "flake.nix";
          programs = {
            statix.enable = true;
            alejandra.enable = true;
            prettier.enable = true;
            actionlint.enable = true;
          };
          flakeCheck = false;
        };

        pre-commit.settings = {
          hooks.treefmt.enable = true;
        };
      };
    });

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://bricked.cachix.org"
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://statix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "bricked.cachix.org-1:SPpNjrCYzlfisekwWTN7dEUQs+OrirrM92h1ZoEnciY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "statix.cachix.org-1:Z9E/g1YjCjU117QOOt07OjhljCoRZddiAm4VVESvais="
    ];
  };

  inputs = {
    # Nix
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    systems.url = "github:nix-systems/default-linux";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flakes
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-compat.url = "github:edolstra/flake-compat";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    gitignore = {
      url = "github:hercules-ci/gitignore";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hooks
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Preferences
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
    };

    nixdg-ninja = {
      url = "github:notashelf/nixdg-ninja";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Boot
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks-nix.follows = "git-hooks";
    };

    # Programs
    mithril-shell = {
      url = "github:bricked-contrib/mithril-shell";
      # Don't override nixpkgs input as advised in
      # https://andreashgk.github.io/mithril-shell/getting-started/installation#setup
      inputs.home-manager.follows = "home-manager";
      inputs.flake-utils.follows = "flake-utils";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-nspawn = {
      url = "github:fpletz/nixos-nspawn/946929c07e5b3f4500d8feede0759494b33de884";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.git-hooks.follows = "git-hooks";
    };

    # Assets
    wallpaper = {
      url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/40912e6418737e93b59a38bcf189270cbf26656d/pink-clouds.jpg";
      flake = false;
    };
  };
}
