{self, ...}: {
  imports = [self.homeModules.all];

  # Nix
  nixpkgs.config.allowUnfree = true;
  programs.nix-your-shell.enable = true;

  # Home
  programs.home-manager.enable = true;

  home = {
    stateVersion = "26.05";
    username = "personal";
    homeDirectory = "/home/personal";
    keyboard.layout = "de";
  };

  # Theming
  stylix.enable = true;
  services.mithril-shell.enable = true;

  # Shell
  programs.direnv.enable = true;
  programs.eza.enable = true;
  programs.fish.enable = true;
  programs.git.enable = true;
  programs.gpg.enable = true;
  programs.nushell.enable = true;
  programs.starship.enable = true;
  programs.tealdeer.enable = true;
  programs.zoxide.enable = true;

  # Editor
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  # Apps
  programs.ghostty.enable = true;
  programs.librewolf.enable = true;
  programs.fenix.enable = true;
}
