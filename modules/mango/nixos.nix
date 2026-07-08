{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;

  cfg = config.programs.mango;
in {
  imports = [inputs.mangowm.nixosModules.mango];

  options.programs.mango = {
    withUWSM = mkEnableOption "launching Mango with UWSM";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.mango.withUWSM = true;

      services.pipewire.enable = true;
      services.playerctld.enable = true;

      environment.systemPackages = [pkgs.brightnessctl];
    }

    (mkIf cfg.withUWSM {
      programs.mango.addLoginEntry = false;

      programs.uwsm = {
        enable = true;
        waylandCompositors.mango = {
          prettyName = "Mango";
          comment = "Mango compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/mango";
        };
      };
    })
  ]);
}
