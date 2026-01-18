{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) fromTOML readFile;
  inherit (lib) mkIf;

  cfg = config.programs.starship;

  loadPreset = name: fromTOML (readFile "${pkgs.starship}/share/starship/presets/${name}.toml");

  plainTextSymbols = loadPreset "plain-text-symbols";
in {
  config = mkIf cfg.enable {
    programs.starship.settings = plainTextSymbols;
  };
}
