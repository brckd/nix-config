{self, ...}: {
  imports = [self.homeModules.all];

  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "25.11";
    username = "personal";
    homeDirectory = "/home/personal";
  };

  programs.home-manager.enable = true;

  # Theming
  stylix.enable = true;
  services.mithril-shell.enable = true;

  # Terminal
  programs.fish.enable = true;
  programs.starship.enable = true;
  programs.direnv.enable = true;
  programs.ghostty.enable = true;
  programs.git.enable = true;
  programs.gpg.enable = true;
  programs.gh.enable = true;
  programs.zoxide.enable = true;

  # Editor
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };
  programs.vscode.enable = true;

  # Apps
  programs.librewolf.enable = true;
  programs.spicetify.enable = true;
}
