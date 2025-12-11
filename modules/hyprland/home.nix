{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types range mapAttrsToList;

  cfg = config.wayland.windowManager.hyprland;

  workspaceToKey = ws:
    if ws == 10
    then 0
    else ws;

  mkSwitchWorkspaceBind = ws: "${cfg.keys.modifiers.main}, ${toString (workspaceToKey ws)}, workspace, ${toString ws}";

  mkMoveToWorkspaceBind = ws: "${cfg.keys.modifiers.main} ${cfg.keys.modifiers.alt}, ${toString (workspaceToKey ws)}, movetoworkspace, ${toString ws}";

  mkDirectionOption = direction: default:
    mkOption {
      inherit default;
      type = types.str;
      description = "The key to move ${direction}.";
    };

  mkDirection = dir:
    {
      up = "u";
      down = "d";
      left = "l";
      right = "r";
    }.${
      dir
    };

  toggleAnyrun = "pgrep anyrun && pkill anyrun || ${config.programs.anyrun.package}/bin/anyrun";
in {
  options.wayland.windowManager.hyprland = {
    keys = {
      modifiers = {
        main = mkOption {
          type = types.str;
          description = "Modifier key to use for window management actions.";
          default = "SUPER";
        };
        alt = mkOption {
          type = types.str;
          description = "Modifier key to use for secondary window management actions.";
          default = "SHIFT";
        };
      };
      directions = {
        up = mkDirectionOption "up" "K";
        down = mkDirectionOption "down" "J";
        left = mkDirectionOption "left" "H";
        right = mkDirectionOption "right" "L";
      };
    };
    volume = {
      step = mkOption {
        type = types.float;
        description = "Value to change the volume by when using the volume keys.";
        default = 0.05;
      };
      limit = mkOption {
        type = types.float;
        description = "Maximum value of the volume.";
        default = 1.0;
      };
    };
    scrolling.enableNatural = mkEnableOption "natural scrolling";
  };

  config = mkIf cfg.enable {
    programs.hyprlock.enable = true;
    wayland.windowManager.hyprland = {
      systemd.enable = false;
      settings = {
        input = {
          kb_layout = config.home.keyboard.layout;
          touchpad.natural_scroll = true;
        };
        monitor = ",highres,auto,1";

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 0;
        };

        decoration = {
          rounding = 15;
        };

        animations = {
          enabled = true;
          bezier = "easeInOut, 0.5, 0, 0, 1";
          animation = [
            "windows, 1, 3, easeInOut"
            "windowsOut, 1, 3, easeInOut, popin 80%"
            "workspaces, 1, 3, easeInOut"
            "border, 1, 3, easeInOut"
            "borderangle, 1, 3, easeInOut"
            "fade, 1, 3, easeInOut"
          ];
        };

        binds.scroll_event_delay = 0;

        bind =
          [
            "${cfg.keys.modifiers.main}, Q, killactive"
            "${cfg.keys.modifiers.main} ${cfg.keys.modifiers.alt}, Q, exec, ${pkgs.uwsm}/bin/uwsm stop"
            "${cfg.keys.modifiers.main}, D, togglefloating"
            "${cfg.keys.modifiers.main}, F, fullscreen"
            "${cfg.keys.modifiers.main}, T, exec, ghostty"
            "${cfg.keys.modifiers.main}, mouse_${
              if cfg.scrolling.enableNatural
              then "down"
              else "up"
            }, workspace, r-1"
            "${cfg.keys.modifiers.main}, mouse_${
              if cfg.scrolling.enableNatural
              then "up"
              else "down"
            }, workspace, r+1"
          ]
          ++ map mkMoveToWorkspaceBind (range 1 10)
          ++ map mkSwitchWorkspaceBind (range 1 10)
          ++ mapAttrsToList (dir: key: "${cfg.keys.modifiers.main}, ${key}, movefocus, ${mkDirection dir}") cfg.keys.directions
          ++ mapAttrsToList (dir: key: "${cfg.keys.modifiers.main} ${cfg.keys.modifiers.alt}, ${key}, movewindow, ${mkDirection dir}") cfg.keys.directions;

        bindl = [
          ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ];

        bindle = [
          ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume --limit ${toString cfg.volume.limit} @DEFAULT_AUDIO_SINK@ ${toString cfg.volume.step}-"
          ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume --limit ${toString cfg.volume.limit} @DEFAULT_AUDIO_SINK@ ${toString cfg.volume.step}+"
        ];

        bindr = [
          "${cfg.keys.modifiers.main}, Super_L, exec, ${toggleAnyrun}"
        ];

        bindm = [
          "${cfg.keys.modifiers.main}, mouse:272, movewindow"
          "${cfg.keys.modifiers.main}, mouse:273, resizewindow"
        ];

        gesture = [
          "3, horizontal, workspace"
          "3, vertical, dispatcher, exec, ${toggleAnyrun}"
        ];
      };
    };
  };
}
