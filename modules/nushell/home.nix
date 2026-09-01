{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.nushell;
in {
  config = mkIf cfg.enable {
    programs.nushell = {
      environmentVariables = {
        PROMPT_INDICATOR_VI_NORMAL = "";
        PROMPT_INDICATOR_VI_INSERT = "";
      };

      settings = {
        buffer_editor = "hx";
        cursor_shape.helix_insert = "line";
        cursor_shape.helix_normal = "block";
        edit_mode = "helix";
        rm.always_trash = true;
        show_banner = false;

        abbreviations = {
          # Unix
          cpr = "cp --recursive";

          # Nix
          nr = "nix run";
          nf = "nix flake";
          nfu = "nix flake update";
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
          gpl = "git pull";
          ga = "git add";
          gaa = "git add .";
          gap = "git add --patch";
          gd = "git diff";
          gdn = "git diff --name-only";
          gdh = "git diff HEAD~ HEAD";
          gdc = "git diff --cached";
          gdcn = "git diff --cached --name-only";
          gcp = "git cherry-pick";
          gs = "git switch";
        };
      };
    };
  };
}
