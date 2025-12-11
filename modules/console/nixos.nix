{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.console;
in {
  config = mkIf cfg.enable {
    console = {
      useXkbConfig = true;
    };
  };
}
