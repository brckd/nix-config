{self, ...}: {
  imports = [self.homeModules.all];

  # Nix
  nixpkgs.config.allowUnfree = true;
  programs.nix-your-shell.enable = true;

  # Home
  programs.home-manager.enable = true;

  home = {
    stateVersion = "25.11";
    username = "personal";
    homeDirectory = "/home/personal";
    keyboard.layout = "de";
  };

  # Theming
  stylix.enable = true;
  services.mithril-shell.enable = true;

  # Shell
  programs.fish.enable = true;
  programs.direnv.enable = true;
  programs.git.enable = true;
  programs.gpg.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  # Editor
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  # Apps
  programs.ghostty.enable = true;
  programs.librewolf.enable = true;
  programs.spicetify.enable = true;
}
