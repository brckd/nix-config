{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.programs.nautilus;
in {
  imports = [./extensions];

  options.programs.nautilus = {
    enable = mkEnableOption "Nautilus";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.nautilus];
  };
}
