{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.ghostty;
in {
  config = mkIf cfg.enable {
    programs.ghostty.settings = {
      gtk-titlebar = true;
      window-decoration = "client";
      window-padding-x = 10;
      window-padding-y = 10;
    };
  };
}
