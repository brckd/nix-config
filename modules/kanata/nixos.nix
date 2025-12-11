{
  lib,
  config,
  ...
}: let
  inherit (builtins) attrNames concatStringsSep mapAttrs concatLists replaceStrings typeOf;
  inherit (lib) mkIf mapAttrsToList concatMapAttrs concatMapAttrsStringSep unique;

  cfg = config.services.kanata;

  tapTime = 300;
  holdTime = 300;
  layers = {
    base =
      mapAttrs (k: v: v // {mod = true;}) {
        a.hold = "lmet";
        s.hold = "lalt";
        d.hold = "lsft";
        f.hold = "lctl";
        j.hold = "rctl";
        k.hold = "rsft";
        l.hold = "ralt";
        ";".hold = "rmet";
      }
      // {
        caps = {
          tap = "esc";
          hold = "(layer-switch plain)";
        };
      };
    plain = {
      caps = {
        tap = "esc";
        hold = "(layer-switch base)";
      };
    };
  };

  mkSExp = value:
    if typeOf value == "list"
    then "(${concatStringsSep " " (map mkSExp value)})"
    else if typeOf value == "set"
    then "\n  ${replaceStrings ["\n"] ["\n  "] (concatMapAttrsStringSep "\n" (name: value: "${name} ${mkSExp value}") value)}\n"
    else toString value;
in {
  config = mkIf cfg.enable {
    services.kanata = {
      keyboards.default = {
        extraDefCfg = ''
          process-unmapped-keys yes
        '';
        config = concatStringsSep "\n\n" (map mkSExp (
          [
            (["defsrc"] ++ (unique (concatLists (mapAttrsToList (layer: attrNames) layers))))
          ]
          ++ (mapAttrsToList (layer: keys: [
              "deflayermap"
              [layer]
              (concatMapAttrs (key: alias: {
                  ${key} = let
                    action = ["tap-hold" tapTime holdTime (alias.tap or key) (alias.hold or key)];
                  in
                    if alias.mod or false
                    then ["multi" "f24" action]
                    else action;
                })
                keys)
            ])
            layers)
        ));
      };
    };
  };
}
