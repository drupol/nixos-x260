{
  config,
  pkgs,
  lib,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
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

  networking = {
    hostName = "raspberryPi400";
    useDHCP = false;

    networkmanager = {
      enable = true;
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 53 67 80 ];
      allowedUDPPorts = [ 53 67 ];
      checkReversePath = false;
    };

    interfaces = {
      end1 = {
        name = "wan";

        ipv4.addresses = [{
          address = "192.168.1.2";
          prefixLength = 24;
        }];

        macAddress = "00:0e:c6:52:c6:b3";
      };
    };

    defaultGateway = "192.168.1.1";
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

  virtualisation = {
    oci-containers = {
      backend = "docker";

      containers = {
        pi-hole = import ./pi-hole.nix;
      };
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.disable_ipv6" = 1;
}
