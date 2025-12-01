{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.git;
in {
  config = mkIf cfg.enable {
    programs.git = {
      settings = {
        push.autoSetupRemote = true;
        pull.rebase = true;
        pager = {
          diff = "${pkgs.riffdiff}/bin/riff";
          show = "${pkgs.riffdiff}/bin/riff";
          log = "${pkgs.riffdiff}/bin/riff";
        };
        interactive.diffFilter = "${pkgs.riffdiff}/bin/riff";
      };
    };
  };
}
