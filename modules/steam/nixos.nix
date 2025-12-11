{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.steam;
in {
  config = mkIf cfg.enable {
    programs.steam = {
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
