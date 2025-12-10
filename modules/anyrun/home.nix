{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.anyrun;
in {
  config = mkIf cfg.enable {
    programs.anyrun = {
      config = {
        closeOnClick = true;

        plugins = [
          "${cfg.package}/lib/libapplications.so"
          "${cfg.package}/lib/libsymbols.so"
          "${cfg.package}/lib/librink.so"
        ];
      };

      extraCss = builtins.readFile ./style.css;
    };
  };
}
