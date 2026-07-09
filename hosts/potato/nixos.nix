{
  pkgs,
  inputs,
  self,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  agenixPkgs = inputs.agenix.packages.${system};
  diskoPkgs = inputs.disko.packages.${system};
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
  system.stateVersion = "26.05";
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["@wheel"];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
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

  # Networking
  services.openssh = {
    enable = true;
    openFirewall = false;
    listenAddresses = [];

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Theming
  stylix.enable = true;

  # Locale
  time.timeZone = "Europe/Berlin";
  services.xserver.xkb.layout = "de";

  # Desktop
  services.displayManager.gdm.enable = true;
  programs.mango.enable = true;

  services.gremlin-shell = {
    enable = true;
    applications.enableCore = true;
    applications.enableDeveloper = true;
  };

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
  programs.fenix.enable = true;

  environment.systemPackages = [
    agenixPkgs.agenix
    diskoPkgs.disko
    pkgs.alejandra
    pkgs.bacon
    pkgs.cargo-flamegraph
    pkgs.gcc
    pkgs.home-manager
    pkgs.nix-melt
    pkgs.nurl
    pkgs.proton-vpn
    pkgs.ripgrep
    pkgs.tuba # Mastodon client
    pkgs.vesktop # Discord client
  ];
}
