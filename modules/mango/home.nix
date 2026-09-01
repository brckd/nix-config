{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mapAttrsToList mkIf;
  inherit (config.lib.stylix) colors;

  cfg = config.wayland.windowManager.mango;

  backgroundColor = "0x${colors.base0D}ff";
  borderColor = "0x${colors.base01}ff";
  gap = 10;

  directions = {
    left = "H";
    right = "L";
    up = "K";
    down = "J";
  };

  stackDirections = {
    next = "I";
    prev = "U";
  };

  eachTag = f: builtins.genList f 10;
  eachDirection = f: mapAttrsToList f directions;
  eachStackDirection = f: mapAttrsToList f stackDirections;

  toggleAnyrunScript =
    pkgs.writeShellScript "toggle-anyrun"
    ''
      anyrun_is_active="''${XDG_STATE_HOME:-$HOME/.local/state}/anyrun_is_active"

      if [ -f "$anyrun_is_active" ]; then
        anyrun close
      else
        mkdir --parents $(dirname "$anyrun_is_active")
        touch "$anyrun_is_active"
        anyrun
      fi

      rm "$anyrun_is_active"
    '';
in {
  imports = [inputs.mangowm.hmModules.mango];

  config = mkIf cfg.enable {
    services.swayosd.enable = true;

    wayland.windowManager.mango = {
      settings = {
        exec-once = ["anyrun daemon"];

        # Scaling
        monitorrule = "model:U28E590,scale:1.5";

        # Spacing
        border_radius = 20;
        borderpx = 3;
        gappih = gap;
        gappiv = gap;
        gappoh = gap;
        gappov = gap;

        # Palette
        rootcolor = backgroundColor;
        bordercolor = borderColor;
        focuscolor = borderColor;
        splitcolor = borderColor;
        urgentcolor = borderColor;

        # Animation
        animation_duration = {
          move = 300;
          open = 300;
        };

        # Layout
        tagrule = eachTag (tag: "id:${toString tag},layout_name:fair");

        # Input
        trackpad.natural_scrolling = 1;
        drag_tile_to_tile = 1;
        xkb_rules.layout = config.home.keyboard.layout;

        # Binds
        axisbind = [
          "super,up,viewtoleft_have_client"
          "super,down,viewtoright_have_client"
        ];

        bind =
          [
            "super,t,spawn,ghostty"
            "super,r,spawn,${toggleAnyrunScript}"
            "super,Super_L,spawn,${toggleAnyrunScript}"
            "super,Super_R,spawn,${toggleAnyrunScript}"
            "super,q,killclient"
            "super,tab,toggleoverview"
            "super+shift,q,quit"
            "super,d,togglefloating"
            "super,f,togglefullscreen"
            "super,m,zoom"
            "none,XF86MonBrightnessUp,spawn,swayosd-client --brightness raise"
            "none,XF86MonBrightnessDown,spawn,swayosd-client --brightness lower"
            "none,XF86AudioRaiseVolume,spawn,swayosd-client --output-volume raise"
            "none,XF86AudioLowerVolume,spawn,swayosd-client --output-volume lower"
            "none,XF86AudioMute,spawn,swayosd-client --output-volume mute-toggle"
            "none,XF86AudioNext,spawn,swayosd-client --playerctl next"
            "none,XF86AudioPrev,spawn,swayosd-client --playerctl previous"
            "none,XF86AudioPlay,spawn,swayosd-client --playerctl play-pause"
          ]
          ++ eachTag (tag: "super,${toString tag},view,${toString tag}")
          ++ eachTag (tag: "super+shift,${toString tag},tag,${toString tag}")
          ++ eachDirection (dir: key: "super,${key},focusdir,${dir}")
          ++ eachStackDirection (dir: key: "super,${key},focusstack,${dir}")
          ++ eachDirection (dir: key: "super+shift,${key},exchange_client,${dir}")
          ++ eachStackDirection (dir: key: "super+shift,${key},exchange_stack_client,${dir}");

        gesturebind = [
          "none,right,3,viewtoleft_have_client"
          "none,left,3,viewtoright_have_client"
        ];

        mousebind = [
          "super,btn_left,moveresize,curmove"
          "super,btn_right,moveresize,curresize"
        ];
      };
    };
  };
}
