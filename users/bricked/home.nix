{
  self,
  pkgs,
  ...
}: {
  imports = [self.homeModules.all];

  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "25.11";
    username = "bricked";
    homeDirectory = "/home/bricked";
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
  services.gnome-keyring.enable = true;
  programs.gpg.enable = true;
  programs.gh.enable = true;
  programs.zoxide.enable = true;
  programs.nix-your-shell.enable = true;

  # Editor
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  # Apps
  programs.librewolf.enable = true;
  programs.spicetify.enable = true;
}
