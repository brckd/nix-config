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
  wayland.windowManager.mango.enable = true;
  services.gremlin-shell.enable = true;

  # Shell
  programs.direnv.enable = true;
  programs.eza.enable = true;
  programs.fish.enable = true;
  programs.gpg.enable = true;
  programs.nushell.enable = true;
  programs.starship.enable = true;
  programs.tealdeer.enable = true;
  programs.zoxide.enable = true;

  # Git
  programs.git.enable = true;

  programs.mergiraf = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
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
