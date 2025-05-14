{ lib, ... }:
{
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

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/var/log" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "nosuid"
        "noatime"
      ];
    };
    "/tmp" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=1G"
        "nosuid"
        "noatime"
      ];
    };
  };

  systemd.network.networks = {
    wan = {
      DHCP = "no";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "00:0e:c6:52:c6:b3";
      addresses = [ { addressConfig.Address = "192.168.1.2/24"; } ];
      routes = [ { routeConfig.Gateway = "192.168.1.1"; } ];
      dns = [ "8.8.8.8" ];
    };
    lan = {
      DHCP = "no";
      linkConfig.RequiredForOnline = "no";
      matchConfig.MACAddress = "dc:a6:32:e5:bf:9e";
      networkConfig = {
        IPMasquerade = "yes";
      };
      addresses = [ { addressConfig.Address = "192.168.2.10/24"; } ];
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;
  services.resolved.enable = false;

  networking = {
    domain = "lan";
    hostName = "router";
    useNetworkd = true;
    useDHCP = false;

    firewall = {
      enable = true;
      extraCommands = ''
        iptables -t nat -A PREROUTING ! -s 192.168.2.10 -p udp --dport 53 -j DNAT --to 192.168.2.10
        iptables -t nat -A PREROUTING ! -s 192.168.2.10 -p tcp --dport 53 -j DNAT --to 192.168.2.10
        iptables -I INPUT -p tcp --sport 853 -j DROP
        iptables -I INPUT -p udp --sport 853 -j DROP
        iptables -I OUTPUT -p tcp --dport 853 -j DROP
        iptables -I OUTPUT -p udp --dport 853 -j DROP
      '';
    };
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.11";

  hardware.enableRedistributableFirmware = true;

  virtualisation = {
    docker = {
      autoPrune = {
        dates = "daily";
        flags = [
          "--all"
          "--volumes"
        ];
      };
      enable = true;
    };
  };
}
