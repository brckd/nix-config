{
  inputs,
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
      dnsovertls = "true";
    };
  };

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

      internal = rec {
        address = "${prefix}::2";
        subnet = mkSubnet address prefixLength;
      };
    };

    dittoBot = rec {
      prefix = "${networks.public.prefix}:ede1";
      prefixLength = 96;

      gateway = rec {
        address = "${prefix}::1";
        subnet = mkSubnet address prefixLength;
      };

      internal = rec {
        address = "${prefix}::2";
        subnet = mkSubnet address prefixLength;
      };
    };

    greggBot = rec {
      prefix = "${networks.public.prefix}:868d";
      prefixLength = 96;

      gateway = rec {
        address = "${prefix}::1";
        subnet = mkSubnet address prefixLength;
      };

      internal = rec {
        address = "${prefix}::2";
        subnet = mkSubnet address prefixLength;
      };
    };

    uptimeKuma = rec {
      prefix = "${networks.public.prefix}:ad5d";
      prefixLength = 96;

      gateway = rec {
        address = "${prefix}::1";
        subnet = mkSubnet address prefixLength;
      };

      internal = rec {
        address = "${prefix}::2";
        subnet = mkSubnet address prefixLength;
      };
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
  system.stateVersion = "26.05";
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
    "crop" = {
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
            Address = [networks.crop.internal.subnet];
            Gateway = [networks.crop.gateway.address];
          };
        };
      };

      config = {
        config = {
          system.stateVersion = "26.05";
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

    "ditto-bot" = {
      autoStart = true;

      binds."/run/agenix-ditto-bot" = {
        options = ["idmap"];
        readOnly = true;
      };

      network.veth.config = {
        host = {
          networkConfig = {
            DHCPServer = false;
            Address = [networks.dittoBot.gateway.subnet];
          };
        };
        container = {
          networkConfig = {
            DHCP = false;
            Address = [networks.dittoBot.internal.subnet];
            Gateway = [networks.dittoBot.gateway.address];
          };
        };
      };

      config = {
        imports = [inputs.ditto-bot.nixosModules.default dnsModule];

        system.stateVersion = "26.05";

        services.ditto-bot = {
          enable = true;
          envFile = "/run/agenix-ditto-bot/.env";
        };
      };
    };

    "gregg-bot" = {
      autoStart = true;

      binds."/run/agenix-gregg-bot" = {
        options = ["idmap"];
        readOnly = true;
      };

      network.veth.config = {
        host = {
          networkConfig = {
            DHCPServer = false;
            Address = [networks.greggBot.gateway.subnet];
          };
        };
        container = {
          networkConfig = {
            DHCP = false;
            Address = [networks.greggBot.internal.subnet];
            Gateway = [networks.greggBot.gateway.address];
          };
        };
      };

      config = {
        imports = [inputs.gregg-bot.nixosModules.default dnsModule];

        system.stateVersion = "26.05";

        services.gregg-bot = {
          enable = true;
          envFile = "/run/agenix-gregg-bot/.env";
        };

        services.postgresql = {
          enable = true;
          ensureDatabases = ["gregg"];
          enableTCPIP = true;

          authentication = lib.mkForce ''
            local sameuser all trust
            host sameuser all 127.0.0.1/32 trust
            host sameuser all ::1/128 trust
          '';

          ensureUsers = [
            {
              name = "gregg";
              ensureDBOwnership = true;
            }
          ];
        };
      };
    };

    "uptime-kumma" = {
      autoStart = true;

      network.veth.config = {
        host = {
          networkConfig = {
            DHCPServer = false;
            Address = [networks.uptimeKuma.gateway.subnet];
          };
        };
        container = {
          networkConfig = {
            DHCP = false;
            Address = [networks.uptimeKuma.internal.subnet];
            Gateway = [networks.uptimeKuma.gateway.address];
          };
        };
      };

      config = {
        imports = [dnsModule];

        system.stateVersion = "26.05";
        networking.firewall.allowedTCPPorts = [80 443];

        services.uptime-kuma = {
          enable = true;

          settings = {
            HOST = networks.uptimeKuma.internal.address;
            PORT = "8080";
          };
        };

        services.caddy = {
          inherit (acme) email;
          enable = true;
          virtualHosts."status.bricked.dev".extraConfig = ''
            reverse_proxy http://[${networks.uptimeKuma.internal.address}]:8080
          '';
        };
      };
    };
  };

  # Secrets
  age.secrets = {
    dittoBotEnv = {
      path = "/run/agenix-ditto-bot/.env";
      symlink = false;
    };

    greggBotEnv = {
      path = "/run/agenix-gregg-bot/.env";
      symlink = false;
    };
  };

  # Networking
  networking = {
    inherit hostName;
    useNetworkd = true;
    useDHCP = false;
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
