{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  cfg = config.services.mithril-shell;
in {
  imports = [inputs.mithril-shell.homeManagerModules.default];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.enable = true; # Wayland compositor
    programs.anyrun.enable = true;
    services.swaync.enable = true; # Notification daemon
    services.gnome-keyring.enable = true; # Secrets manager
    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-gnome3; # Passphrase input
      pinentry.program = "pinentry-gnome3";
    };
    services.udiskie.enable = true;

    services.mithril-shell = mkMerge [
      {
        integrations.hyprland.enable = true;
      }

      (mkIf (config.stylix.enable && cfg.integrations.stylix.enable) {
        theme.colors.primary = config.lib.stylix.colors.base0D;
        settings = {
          lockCommand = "${pkgs.hyprlock}/bin/hyprlock --immediate";
          powerMenuEntries = [
            {
              label = "Suspend";
              command = "systemctl suspend";
            }
            {
              label = "Restart";
              command = "systemctl reboot";
              confirmation = "Are you sure you want to restart the computer?";
            }
            {
              label = "Restart to UEFI";
              command = "systemctl reboot --firmware-setup";
              confirmation = "Are you sure you want to restart to UEFI?";
            }
            {
              label = "Power Off";
              command = "systemctl poweroff";
              confirmation = "Are you sure you want to power off the computer?";
            }
            {
              label = "Log Out";
              command = "uwsm stop";
              confirmation = "Are you sure you want to log out of this session?";
            }
          ];
        };
      })
    ];
  };
}
