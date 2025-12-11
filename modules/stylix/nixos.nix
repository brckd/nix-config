{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.stylix;
in {
  imports = [
    ./common.nix
    inputs.stylix.nixosModules.stylix
  ];
  config = mkIf cfg.enable {
    stylix = {
      homeManagerIntegration.autoImport = false;
      targets.plymouth.enable = false;
      targets.qt.enable = true;
      targets.gtksourceview.enable = false;
    };
  };
}
