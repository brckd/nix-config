{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.stylix;
in {
  config = mkIf cfg.enable {
    stylix = {
      image = inputs.wallpaper;
      base16Scheme = ./coal.yaml;

      fonts = rec {
        sansSerif = {
          package = pkgs.lexend;
          name = "Lexend";
        };
        serif = sansSerif;
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
      };
    };
  };
}
