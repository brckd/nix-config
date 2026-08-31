{self, ...}: {
  imports = [self.homeModules.all];

  # Nix
  nixpkgs.config.allowUnfree = true;
  programs.nix-your-shell.enable = true;

  # Home
  programs.home-manager.enable = true;

  home = {
    stateVersion = "26.05";
    username = "bricked";
    homeDirectory = "/home/bricked";
    keyboard.layout = "de";
  };

  # Theming
  stylix.enable = true;
  wayland.windowManager.mango.enable = true;
  services.gremlin-shell.enable = true;

  # Shell
  programs.carapace.enable = true;
  programs.direnv.enable = true;
  programs.eza.enable = true;
  programs.fish.enable = true;
  programs.gpg.enable = true;
  programs.nushell.enable = true;
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
      key = "7B28 3F98 065C CDAC A4BF F235 0448 5EA0 7F3F AB31";
    };
  };

  # Editor
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  # Apps
  programs.ghostty.enable = true;
  programs.librewolf.enable = true;
  programs.rust.enable = true;
}
