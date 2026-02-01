{
  pkgs,
  inputs,
  self,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  diskoPkgs = inputs.disko.packages.${system};
  fenixPkgs = inputs.fenix.packages.${system}.stable;
  hytalePkgs = inputs.hytale-launcher-nix.packages.${system};
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

  environment.etc."nixos".source = self.outPath;

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

    kernelParams = [
      "zswap.enabled=1"
      "zswap.compressor=lz4"
      "zswap.max_pool_percent=25"
      "zswap.shrinker_enabled=1"
    ];
  };

  systemd.tpm2.enable = false;

  # Theming
  stylix.enable = true;

  # Locale
  time.timeZone = "Europe/Berlin";
  services.xserver.xkb.layout = "de";
  services.kanata.enable = true;

  # Desktop
  services.displayManager.gdm.enable = true;
  services.mithril-shell.enable = true;

  # Shell
  console.useXkbConfig = true;
  programs.fish.enable = true;
  programs.nushell = {
    enable = true;
    defaultUserShell = true;
  };

  # Programs
  programs.spicetify.enable = true;
  programs.adwaita-demo.enable = true;

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
    hytalePkgs.hytale-launcher
    pkgs.bacon
    pkgs.cargo-flamegraph
    pkgs.fd
    pkgs.gcc
    pkgs.home-manager
    pkgs.hyperfine
    pkgs.icon-library
    pkgs.jaq
    pkgs.moor
    pkgs.nurl
    pkgs.nix-melt
    pkgs.protonvpn-gui
    pkgs.ripgrep
    pkgs.sd
    pkgs.ungoogled-chromium
    pkgs.vesktop
    pkgs.xh
  ];
}
