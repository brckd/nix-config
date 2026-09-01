{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.git;
in {
  config = mkIf cfg.enable {
    programs.git = {
      settings = {
        pull.rebase = true;
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
      };
    };
  };
}
