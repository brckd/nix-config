{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.direnv;
in {
  config = mkIf cfg.enable {
    programs.direnv = {
      nix-direnv.enable = true;
    };
  };
}
