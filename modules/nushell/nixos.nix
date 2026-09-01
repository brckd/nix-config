{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) getExe mkIf mkMerge mkEnableOption mkPackageOption;

  cfg = config.programs.nushell;
in {
  options.programs.nushell = {
    defaultUserShell = mkEnableOption "Nushell as the default user shell";
  };

  config = mkIf (cfg.enable && cfg.defaultUserShell) {
    users.defaultUserShell = pkgs.dash;
    environment.sessionVariables.ENV =
      pkgs.writeShellScript "dashInit"
      ''
        if ! [ "$TERM" = "dumb" ]; then
          exec ${getExe cfg.package}
        fi
      '';
  };
}
