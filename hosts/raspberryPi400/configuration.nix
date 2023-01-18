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

    nat = {
      enable = true;
      internalInterfaces = ["end0"];
      externalInterface = "enp1s0u1u2";
    };

    networkmanager = {
      enable = true;
    };
    # useNetworkd = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [53 67 80 8888 9990 9991];
      allowedUDPPorts = [53 67];
      checkReversePath = false;
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
    oci-containers = {
      backend = "docker";

      containers = {
        pi-hole = import ./pi-hole.nix;
      };
    };
  };
}
