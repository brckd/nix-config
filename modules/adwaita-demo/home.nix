{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.adwaita-demo;
in {
  options.programs.adwaita-demo = {
    enable = lib.mkEnableOption "Adwaita Demo";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.libadwaita.devdoc];

    xdg.desktopEntries.adwaitaDemo = {
      name = "Adwaita Demo";
      exec = "adwaita-1-demo";
      icon = "org.gnome.Adwaita1.Demo-symbolic";
      terminal = false;
      categories = ["Development"];
    };
  };
}
