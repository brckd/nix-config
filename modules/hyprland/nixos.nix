{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.hyprland;
in {
  config = mkIf cfg.enable {
    programs.hyprland.withUWSM = true;
    programs.hyprlock.enable = true;
    services.pipewire.wireplumber.enable = true;
    services.playerctld.enable = true;
  };
}
