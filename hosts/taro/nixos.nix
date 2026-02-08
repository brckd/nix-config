{
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib) singleton;

  mkSubnet = gateway: prefixLength: "${gateway}/${toString prefixLength}";

  hostName = "taro";
  ssh.ports = [1450];
  acme.email = concatStringsSep "i" ["sapl" "ng@br" "cked.dev"];

  # IPv6 proxy using https://nat64.net/
  # Hostnames are resolved syntax for DNS over TLS
  nameservers = [
    "2a01:4f8:c2c:123f::1#dot.nat64.dk"
    "2a00:1098:2b::1#dot.nat64.dk"
    "2a00:1098:2c::1#dot.nat64.dk"
  ];

  networks = {
    public = rec {
      interface = "enp1s0";
      prefix = "2a01:4f8:1c1f:9442";
      prefixLength = 64;
      gateway = rec {
        address = "${prefix}::1";
        subnet = mkSubnet address prefixLength;
      };
    };

    local = rec {
      prefix = "fe80";
      prefixLength = 64;
      gateway = rec {
        address = "${prefix}::1";
        subnet = mkSubnet address prefixLength;
      };
    };

    crop = rec {
      prefix = "${networks.public.prefix}:123";
      prefixLength = 96;

      gateway = rec {
        address = "${prefix}::1";
        subnet = mkSubnet address prefixLength;
      };

      app = rec {
        address = "${prefix}::2";
        subnet = mkSubnet address prefixLength;
      };
    };
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
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPmvrI3zA1/iKiJrjcHBgHvsoLJ3xzuE5WKx+2rTHxW"];
    };
  };

  # Containers
  virtualisation.nspawn.containers = {
    crop = {
      autoStart = true;

      network.veth.config = {
        host = {
          networkConfig = {
            DHCPServer = false;
            Address = [networks.crop.gateway.subnet];
          };
        };
        container = {
          networkConfig = {
            DHCP = false;
            Address = [networks.crop.app.subnet];
            Gateway = [networks.crop.gateway.address];
          };
        };
      };

      config = {
        config = {
          system.stateVersion = "25.11";
          networking.firewall.allowedTCPPorts = [80 443];

          services.caddy = {
            inherit (acme) email;
            enable = true;
            virtualHosts."crop.bricked.dev".extraConfig = ''
              respond "Hello, world!"
            '';
          };
        };
      };
    };
  };

  # Networking
  networking = {
    inherit hostName nameservers;
    useNetworkd = true;
    useDHCP = false;
  };

  services.resolved = {
    enable = true;
    domains = ["~."];
    fallbackDns = [];
    dnssec = "true";
    dnsovertls = "true";
  };

  systemd.network = {
    enable = true;

    networks = {
      "10-${networks.public.interface}" = {
        matchConfig.Name = networks.public.interface;
        linkConfig.RequiredForOnline = "routable";
        DHCP = "no";

        address = [networks.public.gateway.subnet];
        routes = singleton {
          Gateway = networks.local.gateway.address;
        };
      };
    };
  };

  services.openssh = {
    enable = true;
    inherit (ssh) ports;

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

  # Programs
  environment.systemPackages = [
    pkgs.git
    pkgs.curl
  ];
}
