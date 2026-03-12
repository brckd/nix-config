{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.fenix;
in {
  imports = [./common.nix];

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
