{
  pkgs,
  inputs,
  self,
  ...
}: let
  fenixPkgs = inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.stable;
in {
  imports = [self.nixosModules.all ./hardware.nix ./disko.nix];

  # System
  system.stateVersion = "25.11";
  networking.hostName = "laptop";
  nixpkgs.config.allowUnfree = true;

  # Users
  users.users = {
    bricked = {
      isNormalUser = true;
      description = "Bricked";
      extraGroups = ["networkmanager" "wheel"];
    };
    personal = {
      isNormalUser = true;
      description = "Personal";
      extraGroups = ["networkmanager" "wheel"];
    };
  };

  # Nix
  nix = {
    package = pkgs.nix;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["@wheel"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };
  programs.nh.enable = true;

  # Boot
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.systemd = {
      enable = true;
      tpm2.enable = false;
    };
    plymouth.enable = true;
    silent = true;
  };
  systemd.tpm2.enable = false;

  # Preferences
  stylix.enable = true;
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_DK.UTF-8";
  services.xserver.xkb.layout = "de";
  services.kanata.enable = true;

  # Desktop
  services.displayManager.gdm.enable = true;
  services.mithril-shell.enable = true;

  # Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Networking
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.flatpak.enable = true;
  environment.systemPackages = [
    (fenixPkgs.withComponents [
      "cargo"
      "clippy"
      "rustfmt"
      "rust-analyzer"
      "rust-docs"
      "rust-src"
    ])
    pkgs.bacon
    pkgs.cargo-flamegraph
    pkgs.eza
    pkgs.fd
    pkgs.gcc
    pkgs.git
    pkgs.hyperfine
    pkgs.jaq
    pkgs.moor
    pkgs.nurl
    pkgs.nix-melt
    pkgs.ripgrep
    pkgs.sd
    pkgs.tealdeer
    pkgs.ungoogled-chromium
    pkgs.vesktop
    pkgs.xh
  ];
}
