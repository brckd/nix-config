{
  inputs,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) singleton;

  hostName = "taro";
  # IPv6 proxy. See https://nat64.xyz/
  nameservers = [
    # See https://nat64.net/
    "2a01:4f8:c2c:123f::1"
    "2a00:1098:2b::1"

    # See https://level66.services/services/nat64/
    "2001:67c:2960::64"
    "2001:67c:2960::6464"
  ];
  interface = "eth0";
  ssh.port = 1450;

  public = rec {
    network = "2a01:4f8:1c1f:9442";
    address = "${network}::1";
    subnet = 64;
  };

  local = rec {
    network = "fe80";
    address = "${network}::1";
  };
in {
  imports = [
    self.nixosModules.all
    ./hardware.nix
    ./disko.nix
  ];

  # Nix
  system.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;

  nix = {
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

  # Bootloader
  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    initrd.systemd.enable = true;

    kernelParams = [
      "zswap.enabled=1"
      "zswap.compressor=lz4"
      "zswap.max_pool_percent=25"
      "zswap.shrinker_enabled=1"
    ];
  };

  # Users
  users.users = {
    almond = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
      initialHashedPassword = "$y$j9T$S01boWs/H/ohg3vJgwD/n/$zariwkA3yVRBznI01dOZfywOgsjZgsQ35bovfiSglK8";
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2FpY9QaN8s4uKrE0UZvMvFqnY10a3MmL5zipuPI7wj"];
    };
  };

  # Networking
  networking = {
    inherit hostName nameservers;

    interfaces.${interface} = {
      ipv6.addresses = singleton {
        inherit (public) address;
        prefixLength = public.subnet;
      };
    };

    defaultGateway6 = {
      inherit (local) address;
      inherit interface;
    };
  };

  services.openssh = {
    enable = true;
    ports = [ssh.port];

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["almond"];
    };
  };

  # Network security
  services.fail2ban.enable = true;

  services.endlessh = {
    enable = true;
    port = 22;
    openFirewall = true;
  };

  # Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  environment.systemPackages = [
    pkgs.git
    pkgs.curl
  ];
}
