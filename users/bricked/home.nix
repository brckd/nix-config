{self, ...}: {
  imports = [self.homeModules.all];

  # Nix
  nixpkgs.config.allowUnfree = true;
  programs.nix-your-shell.enable = true;

  # Home
  programs.home-manager.enable = true;

  home = {
    stateVersion = "25.11";
    username = "bricked";
    homeDirectory = "/home/bricked";
    keyboard.layout = "de";
  };

  # Theming
  stylix.enable = true;
  services.mithril-shell.enable = true;

  # Shell
  programs.direnv.enable = true;
  programs.fish.enable = true;
  programs.gpg.enable = true;
  programs.starship.enable = true;
  programs.tealdeer.enable = true;
  programs.zoxide.enable = true;

  # Git
  programs.git = {
    enable = true;
    settings.user = {
      name = "Bricked";
      email = "rocket@bricked.dev";
    };
    signing = {
      signByDefault = true;
      format = "openpgp";
      key = "A522 E927 3786 E55C 68FA 93E0 B84C 306C 3E35 AB5B";
    };
  };

  # Editor
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  # Apps
  programs.adwaita-demo.enable = true;
  programs.ghostty.enable = true;
  programs.librewolf.enable = true;
  programs.spicetify.enable = true;
}
