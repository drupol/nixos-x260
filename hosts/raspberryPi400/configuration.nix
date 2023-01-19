{
  config,
  pkgs,
  lib,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    tmpOnTmpfs = true;
    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
    kernel = {
      sysctl = {
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;
      };
    };
  };

  console.useXkbConfig = true;

  # Limit the systemd journal to 100 MB of disk or the
  # last 7 days of logs, whichever happens first.
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=5day
  '';

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  # systemd.network.networks = {
  #   "40-wired" = {
  #     enable = true;
  #     name = "end0";
  #     dhcpV4Config.RouteMetric = 1024;
  #     networkConfig = {
  #       IPMasquerade = "yes";
  #     };
  #     matchConfig = {
  #       Name = "end0";
  #       MACAddress = "dc:a6:32:e5:bf:9e";
  #     };
  #     address = "192.168.2.10";
  #     routes = [
  #       {routeConfig = { Gateway = "192.168.1.1"; };}
  #     ];
  #   };
  #   "50-wired" = {
  #     enable = true;
  #     name = "enp1s0u1u2";
  #     dhcpV4Config.RouteMetric = 1024;
  #     networkConfig = {
  #       IPMasquerade = "yes";
  #     };
  #     matchConfig = {
  #       Name = "enp1s0u1u2";
  #       MACAddress = "00:0e:c6:52:c6:b3";
  #     };
  #     address = "192.168.1.2";
  #     routes = [
  #       {routeConfig = { Gateway = "192.168.1.1"; };}
  #     ];
  #   };
  #   "40-wireless" = {
  #     enable = true;
  #     name = "wl*";
  #     dhcpV4Config.RouteMetric = 2048;
  #   };
  #   "40-tunnel" = {
  #     enable = true;
  #     name = "tun*";
  #     linkConfig.Unmanaged = true;
  #   };
  #   "40-bluetooth" = {
  #     enable = true;
  #     name = "bn*";
  #     dhcpV4Config.RouteMetric = 3092;
  #   };
  # };

  networking = {
    hostName = "raspberryPi400";
    useDHCP = false;
    dhcpcd.enable = false;
    usePredictableInterfaceNames = true;

    nat = {
      enable = true;
      internalInterfaces = ["end0"];
      externalInterface = "enp1s0u2";
    };

    interfaces.end0.ipv4.addresses = [
      {
        address = "192.168.2.10";
        prefixLength = 24;
      }
    ];
    interfaces.enp1s0u2.ipv4.addresses = [
      {
        address = "192.168.1.2";
        prefixLength = 24;
      }
    ];

    defaultGateway = "192.168.1.1";

    nameservers = ["127.0.0.1"];

    firewall = {
      enable = true;
      allowedTCPPorts = [53 67 80 8888];
      allowedUDPPorts = [53 67];
      checkReversePath = false;
      extraCommands = ''
        iptables -t nat -A PREROUTING ! -s 192.168.2.10 -p udp --dport 53 -j DNAT --to 192.168.2.10
        iptables -t nat -A PREROUTING ! -s 192.168.2.10 -p tcp --dport 53 -j DNAT --to 192.168.2.10
      '';
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;
  services.grafana = import ./grafana.nix;
  services.prometheus = import ./prometheus.nix;

  system.stateVersion = "23.05";
  system.autoUpgrade = {
    enable = true;
    flake = "github:drupol/nixos-x260";
    allowReboot = true;
  };

  hardware.enableRedistributableFirmware = true;

  virtualisation = {
    containers = {
      enable = true;
      containersConf = {
        settings = {
          engine.helper_binaries_dir = ["${pkgs.netavark}/bin"];
        };
      };
    };

    podman = {
      enable = true;
      dockerCompat = true;
    };

    oci-containers.backend = "podman";
    oci-containers.containers = {
      pi-hole = import ./pi-hole.nix;
    };
  };

  systemd.services = {
    prometheus-pihole-exporter = {
      serviceConfig.ExecStart = lib.mkForce ''
        ${pkgs.bash}/bin/bash -c "${pkgs.prometheus-pihole-exporter}/bin/pihole-exporter \
          -pihole_api_token 4d35bbf234f12338c0617746043c52c1f92e37c9457d8f3d1441feb2036d91b8 \
          -pihole_hostname 127.0.0.1 \
          -pihole_port 80 \
          -pihole_protocol http \
          -port 9006"
      '';
    };
  };

  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/loki 0700 loki loki - -"
    "d /var/lib/loki/ruler 0700 loki loki - -"
  ];

  services.loki = {
    enable = true;
    configuration = {
      # Basic stuff
      auth_enabled = false;
      server = {
        http_listen_port = 3100;
      };
      reporting_enabled = false;

      common = {
        path_prefix = "/var/lib/loki";
        storage.filesystem = {
          chunks_directory = "/var/lib/loki/chunks";
          rules_directory = "/var/lib/loki/rules";
        };
        replication_factor = 1;
        ring = {
          instance_addr = "127.0.0.1";
          kvstore.store = "inmemory";
        };
      };

      schema_config = {
        configs = [
          {
            from = "2022-05-15";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };

      ruler.alertmanager_url = "http://127.0.0.1:9001";
    };
  };
}
