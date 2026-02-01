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
    enable = mkEnableOption "Nushell";
    defaultUserShell = mkEnableOption "Nushell as the default user shell";
    package = mkPackageOption pkgs "nushell" {};
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment = {
        shells = [cfg.package];
        systemPackages = [cfg.package];
      };
    }
    (mkIf cfg.defaultUserShell {
      users.defaultUserShell = pkgs.dash;
      environment.sessionVariables.ENV =
        pkgs.writeShellScript "dashInit"
        ''
          if ! [ "$TERM" = "dumb" ]; then
            exec ${getExe cfg.package}
          fi
        '';
    })
  ]);
}
