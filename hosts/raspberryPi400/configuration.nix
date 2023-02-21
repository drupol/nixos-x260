{
  config,
  pkgs,
  lib,
  ...
}: {
  boot = {
    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
    kernel = {
      sysctl = {
        "net.ipv4.conf.all.forwarding" = lib.mkDefault true;
        "net.ipv6.conf.all.forwarding" = lib.mkDefault true;
      };
    };
  };

  # Limit the systemd journal to 100 MB of disk or the
  # last 3 days of logs, whichever happens first.
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=3day
  '';

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
    "/var/log" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=2G" "nosuid" "noatime"];
    };
    "/tmp" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=1G" "nosuid" "noatime"];
    };
  };

  systemd.network.networks = {
    wan = {
      DHCP = "no";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "00:0e:c6:52:c6:b3";
      addresses = [
        {
          addressConfig.Address = "192.168.1.2/24";
        }
      ];
      routes = [
        {
          routeConfig.Gateway = "192.168.1.1";
        }
      ];
      dns = [
        "100.100.100.100"
        "8.8.8.8"
      ];
    };
    lan = {
      DHCP = "no";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "dc:a6:32:e5:bf:9e";
      networkConfig = {
        IPMasquerade = "yes";
      };
      addresses = [
        {
          addressConfig.Address = "192.168.2.10/24";
        }
      ];
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;
  services.resolved.enable = false;

  networking = {
    hostName = "raspberryPi400";
    useNetworkd = true;
    useDHCP = false;

    firewall = {
      enable = true;
      extraCommands = ''
        iptables -t nat -A PREROUTING ! -s 192.168.2.10 -p udp --dport 53 -j DNAT --to 192.168.2.10
        iptables -t nat -A PREROUTING ! -s 192.168.2.10 -p tcp --dport 53 -j DNAT --to 192.168.2.10
      '';
    };
  };

  security.sudo.wheelNeedsPassword = false;
  services.openssh.enable = true;

  system.stateVersion = "23.05";
  system.autoUpgrade = {
    enable = true;
    flake = "github:drupol/nixos-x260";
    allowReboot = true;
  };

  hardware.enableRedistributableFirmware = true;

  imports = [
    # ./squid.nix
    ./pi-hole.nix
    ./grafana.nix
    ./prometheus.nix
    ./promtail.nix
  ];
}
