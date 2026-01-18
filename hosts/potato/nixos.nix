{
  pkgs,
  inputs,
  self,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  diskoPkgs = inputs.disko.packages.${system};
  fenixPkgs = inputs.fenix.packages.${system}.stable;
in {
  imports = [
    self.nixosModules.all
    ./hardware.nix
    ./disko.nix
  ];

  # System
  networking.hostName = "potato";

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
  system.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;

  nix = {
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

  # Theming
  stylix.enable = true;

  # Locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_DK.UTF-8";
  services.xserver.xkb.layout = "de";
  services.kanata.enable = true;

  # Desktop
  services.displayManager.gdm.enable = true;
  services.mithril-shell.enable = true;

  # Shell
  console.useXkbConfig = true;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Programs
  environment.systemPackages = [
    diskoPkgs.disko
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
    pkgs.icon-library
    pkgs.jaq
    pkgs.moor
    pkgs.nurl
    pkgs.nix-melt
    pkgs.protonvpn-gui
    pkgs.ripgrep
    pkgs.sd
    pkgs.tealdeer
    pkgs.ungoogled-chromium
    pkgs.vesktop
    pkgs.xh
  ];
}
