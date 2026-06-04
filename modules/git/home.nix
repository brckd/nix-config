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
        pager = {
          diff = "${pkgs.riffdiff}/bin/riff";
          show = "${pkgs.riffdiff}/bin/riff";
          log = "${pkgs.riffdiff}/bin/riff";
        };
        pull.rebase = true;
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
        interactive.diffFilter = "${pkgs.riffdiff}/bin/riff";
      };
    };
  };
}
