{
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  config.programs.spicetify = {
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
    ];
  };
}
