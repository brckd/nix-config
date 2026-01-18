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
  programs.zoxide.enable = true;

  # Git
  programs.git = {
    enable = true;
    settings.user = {
      name = "bricked";
      email = "spider@bricked.dev";
    };
    signing = {
      signByDefault = true;
      format = "openpgp";
      key = "1EA6 A3AC FCAF D957 F6BC 727B B125 7D48 58CF 3348";
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
