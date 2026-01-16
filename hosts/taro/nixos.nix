{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib) singleton reverseList;

  hostName = "taro";

  # acme.email = concatStringsSep "" (reverseList [".dev" "cked" "@bri" "lily"]);
  ssh.ports = [1450];

  networks = {
    public = rec {
      interface = "enp1s0";
      prefix = "2a01:4f8:1c1f:9442";
      prefixLength = 64;
      gateway = "${prefix}::1";
      subnet = "${gateway}/${toString prefixLength}";
    };

    local = rec {
      prefix = "fe80";
      prefixLength = 64;
      gateway = "${prefix}::1";
    };

    foo = rec {
      prefix = "${networks.public.prefix}::123";
      prefixLength = 128;
      gateway = prefix;
      subnet = "${gateway}/${toString prefixLength}";
      domain = "foo.bricked.dev";
    };

    bar = rec {
      prefix = "${networks.public.prefix}::456";
      prefixLength = 128;
      gateway = prefix;
      subnet = "${gateway}/${toString prefixLength}";
      domain = "bar.bricked.dev";
    };

    baz = rec {
      prefix = "${networks.public.prefix}::1";
      prefixLength = 128;
      gateway = prefix;
      subnet = "${gateway}/${toString prefixLength}";
      domain = "baz.bricked.dev";
    };
  };

  # Todo: move to modules/dns64/nixos.nix
  dnsModule = {
    # IPv6 proxy using https://nat64.net/
    # Hostnames are resolved syntax for DNS over TLS
    networking.nameservers = [
      "2a01:4f8:c2c:123f::1#dot.nat64.dk"
      "2a00:1098:2b::1#dot.nat64.dk"
      "2a00:1098:2c::1#dot.nat64.dk"
    ];

    services.resolved = {
      enable = true;
      domains = ["~."];
      fallbackDns = [];
      dnssec = "true";
      dnsovertls = "true";
    };
  };
in {
  imports = [
    self.nixosModules.all
    dnsModule
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

  # Containers
  virtualisation.nspawn.containers = {
    foo = {
      autoStart = true;

      network.veth.config = {
        host.networkConfig = {
          DHCPServer = false;
          Address = ["fc42::1/64"];
        };
        container.networkConfig = {
          DHCP = false;
          Address = ["fc42::2/64"];
          Gateway = ["fc42::1"];
        };
      };

      config = {
        # imports = [dnsModule];

        config = {
          system.stateVersion = "25.11";

          services.nginx.enable = true;
          services.nginx.defaultListenAddresses = [networks.foo.gateway];

          networking.firewall.allowedTCPPorts = [80 433];
        };
      };
    };
  };

  # Networking
  networking = {
    inherit hostName;
    useNetworkd = true;
    useDHCP = false;
    firewall.allowedTCPPorts = [80 443];
    # nftables.enable = true;
  };

  systemd.network.networks = {
    "10-${networks.public.interface}" = {
      matchConfig.Name = networks.public.interface;
      linkConfig.RequiredForOnline = "routable";
      DHCP = "no";

      address = [networks.public.subnet];
      routes = singleton {
        Gateway = networks.local.gateway;
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

  # # ACME
  # security.acme = {
  #   acceptTerms = true;
  #   defaults = {
  #     inherit (acme) email;
  #     webroot = "/var/lib/acme/acme-challenge/";
  #   };
  #   certs = {
  #     ${networks.baz.domain} = {
  #       inherit (config.services.nginx) group;
  #     };
  #   };
  # };

  # services.nginx = {
  #   enable = true;
  #   virtualHosts = {
  #     ${networks.baz.domain} = {
  #       forceSSL = true;
  #       useACMEHost = networks.baz.domain;
  #       listenAddresses = ["[${networks.baz.gateway}]"];
  #       locations."/.well-known/acme-challenge" = {
  #         root = config.security.acme.certs.${networks.baz.domain}.webroot;
  #       };
  #     };
  #   };
  # };

  # Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  environment.systemPackages = [
    pkgs.git
    pkgs.curl
  ];
}
