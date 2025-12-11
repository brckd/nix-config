{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;

  cfg = config.boot;
in {
  options.boot = {
    silent = mkEnableOption "silent mode";
  };

  config = mkIf cfg.silent {
    boot = {
      # Enable "Silent Boot"
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];

      loader.timeout = mkDefault 0;
    };
  };
}
