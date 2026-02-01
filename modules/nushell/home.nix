{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf mkMerge singleton types mapAttrsToList;
  inherit (lib.hm.nushell) mkNushellInline;

  cfg = config.programs.nushell;
in {
  options.programs.nushell = {
    shellAbbrs = mkOption {
      type = types.attrsOf types.str;
      default = {};
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.nushell = {
        shellAbbrs = {
          # Unix
          cpr = "cp --recursive";

          # Nix
          nr = "nix run";
          nrs = "nixos-rebuild switch --sudo --flake .";
          nrt = "nixos-rebuild test --sudo --flake .";
          hms = "home-manager switch --flake .";

          # Git
          gl = "git log";
          glo = "git log --oneline";
          gc = "git commit";
          gcm = "git commit --message";
          gca = "git commit --amend";
          gcan = "git commit --amend --no-edit";
          gp = "git push";
          gpf = "git push --force";
          ga = "git add";
          gaa = "git add .";
          gap = "git add --patch";
          gd = "git diff";
          gdn = "git diff --name-only";
          gdh = "git diff HEAD~ HEAD";
          gdc = "git diff --cached";
          gdcn = "git diff --cached --name-only";
        };

        settings = {
          edit_mode = "vi";
          show_banner = false;
          buffer_editor = "hx";
          cursor_shape.vi_normal = "blink_block";
          cursor_shape.vi_insert = "blink_line";
        };

        environmentVariables = {
          PROMPT_INDICATOR_VI_NORMAL = "";
          PROMPT_INDICATOR_VI_INSERT = "";
        };
      };
    }

    (mkIf (cfg.shellAbbrs != {}) {
      programs.nushell = {
        environmentVariables.abbrs =
          mapAttrsToList (name: expansion: {
            inherit name expansion;
            description = "Alias for `${expansion}`";
          })
          cfg.shellAbbrs;

        settings = {
          keybindings = [
            {
              name = "abbr";
              modifier = "none";
              keycode = "space";
              mode = ["emacs" "vi_normal" "vi_insert"];
              event = [
                {
                  send = "menu";
                  name = "abbr_menu";
                }
                {
                  edit = "insertchar";
                  value = " ";
                }
              ];
            }
            {
              name = "abbr";
              modifier = "none";
              keycode = "enter";
              mode = ["emacs" "vi_normal" "vi_insert"];
              event = [
                {
                  send = "menu";
                  name = "abbr_menu";
                }
                {
                  send = "enter";
                }
              ];
            }
          ];
          menus = singleton {
            name = "abbr_menu";
            only_buffer_difference = false;
            marker = "none";
            type = {
              layout = "columnar";
              columns = 1;
              col_width = 20;
              col_padding = 2;
            };
            style = {
              text = "green";
              selected_text = "green_reverse";
              description_text = "yellow";
            };
            source =
              mkNushellInline
              #nu
              ''
                { |buffer, position|
                  let match = $env.abbrs | where name == $buffer

                  if ($match | is-empty) {
                    { value: $buffer }
                  } else {
                    { value: ($match | first).expansion }
                  }
                }
              '';
          };
        };
      };
    })
  ]);
}
