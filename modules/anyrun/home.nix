{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib) mkIf;
  inherit (self.legacyPackages.${pkgs.stdenv.hostPlatform.system}) anyrunPlugins;

  cfg = config.programs.anyrun;
in {
  config = mkIf cfg.enable {
    programs.anyrun = {
      config = {
        closeOnClick = true;

        plugins = [
          "${anyrunPlugins.power}/lib/libpower.so"
          "${cfg.package}/lib/libapplications.so"
          "${cfg.package}/lib/librink.so"
          "${cfg.package}/lib/libsymbols.so"
        ];
      };

      extraCss = readFile ./style.css;
    };
  };
}
