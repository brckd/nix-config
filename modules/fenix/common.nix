{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf mkMerge mkOption types;
  inherit (pkgs.stdenv.hostPlatform) system;

  fenixPkgs = inputs.fenix.packages.${system}.stable;
  cfg = config.programs.fenix;
in {
  options.programs.fenix = {
    enable = mkEnableOption "Fenix Rust toolchain";

    package = mkOption {
      description = "The Fenix package to use.";
      type = types.nullOr types.package;
    };

    components = mkOption {
      description = "The components to enable.";
      type = types.nullOr (types.listOf types.str);
      default = null;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.fenix.package = mkDefault (
        if cfg.components != null
        then fenixPkgs.withComponents cfg.components
        else fenixPkgs.defaultToolchain
      );
    }

    {
      programs.fenix.components = [
        "cargo"
        "clippy"
        "rustfmt"
        "rust-analyzer"
        "rust-docs"
        "rust-src"
      ];
    }
  ]);
}
