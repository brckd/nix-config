{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption replaceString types;
  inherit (pkgs.stdenv.hostPlatform) system;

  rustPkgs = inputs.rust-overlay.packages.${system};
  cfg = config.programs.rust;

  script = replaceString "{{RUST_PKG}}" "${cfg.package}" (builtins.readFile ./rust-doc.nu);
in {
  options.programs.rust = {
    enable = mkEnableOption "Rust toolchain";

    package = mkOption {
      description = "The Rust toolchain to use.";
      type = types.nullOr types.package;

      default = rustPkgs.rust.override {
        extensions = ["rust-analyzer"];
      };
    };

    docs = {
      enable =
        mkEnableOption "Rust documentation script"
        // {
          default = true;
        };

      package = mkOption {
        description = "The Rust documentation script.";
        type = types.nullOr types.package;
        default = null;
      };
    };
  };

  config = mkIf (cfg.enable && cfg.docs.enable) {
    programs.rust.docs.package = pkgs.writers.writeNuBin "rust-doc" script;
  };
}
