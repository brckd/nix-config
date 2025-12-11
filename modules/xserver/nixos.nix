{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.services.xserver;
in {
  config = mkIf cfg.enable {
    services.xserver.excludePackages = [
      pkgs.xterm
    ];
  };
}
