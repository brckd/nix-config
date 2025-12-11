{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.fish;
in {
  config = mkIf cfg.enable {
    programs.fish = {
      interactiveShellInit = ''
        fish_vi_key_bindings
      '';

      shellAbbrs = {
        sh = "$SHELL";
        pg = "$PAGER";
        ed = "$EDITOR";
        g = "git";
        gcl = "git clone";
        gf = "git fetch";
        gp = "git pull";
        gps = "git push";
        gpsf = "git push --force";
        ga = "git add";
        gaa = "git add .";
        gap = "git add --patch";
        grs = "git reset";
        grsh = "git reset --hard";
        gc = "git commit";
        gcm = "git commit --message";
        gca = "git commit --amend";
        gcan = "git commit --amend --no-edit";
        gco = "git checkout";
        gcob = "git checkout -b";
        gd = "git diff";
        gdn = "git diff --name-only";
        gdh = "git diff HEAD~ HEAD";
        gdc = "git diff --cached";
        gdcn = "git diff --cached --name-only";
        gl = "git log";
        glo = "git log --oneline";
        gr = "git rebase";
        gri = "git rebase --interactive --committer-date-is-author-date";
        grc = "git rebase --continue";
        gra = "git rebase --abort";
        gs = "git stash";
        gsa = "git stash apply";
        gcp = "git cherry-pick";
        gcf = "git config";
        n = "nix";
        ns = "nix shell";
        nr = "nix run";
        nrp = "nix repl";
        nf = "nix flake";
        nfm = "nix flake metadata";
        nfu = "nix flake update";
        nhh = "nh home switch .";
        nho = "nh os switch .";
        mkp = "mkdir --parent";
        cpr = "cp --recursive";
        b = "bun";
        bx = "bunx";
        bi = "bun install";
        bid = "bun install --save-dev";
        bu = "bun update";
        br = "bun remove";
        bs = "bun start";
      };
    };
  };
}
