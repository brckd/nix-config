{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.stylix;
in {
  imports = [
    ./common.nix
    inputs.stylix.homeModules.stylix
  ];
  config = mkIf cfg.enable {
    stylix = {
      iconTheme = {
        enable = true;
        package = pkgs.morewaita-icon-theme;
        light = "MoreWaita";
        dark = "MoreWaita";
      };
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      targets.librewolf = {
        profileNames = ["default"];
        firefoxGnomeTheme.enable = true;
      };
    };
  };
}
