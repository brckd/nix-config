{
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  config.programs.spicetify = {
    enabledCustomApps = [
      spicePkgs.apps.marketplace
    ];
  };
}
