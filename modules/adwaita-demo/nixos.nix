{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkPackageOption;

  cfg = config.programs.adwaita-demo;

  desktopEntry = pkgs.makeDesktopItem {
    name = "org.gnome.Adwaita1.Demo.Display";
    desktopName = "Adwaita Demo";
    exec = "adwaita-1-demo";
    icon = "org.gnome.Adwaita1.Demo";
    terminal = false;
    categories = ["GTK"];
  };
in {
  options.programs.adwaita-demo = {
    enable = mkEnableOption "Adwaita Demo";
    package = mkPackageOption pkgs ["libadwaita" "devdoc"] {};
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package desktopEntry];
  };
}
