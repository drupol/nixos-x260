{
  config,
  pkgs,
  lib,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

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
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = false;
      allowedTCPPorts = [];
      checkReversePath = false;
    };
    useDHCP = false;
  };

  security.sudo.wheelNeedsPassword = false; # Use 'sudo' without a password

  services.openssh.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?

  system.autoUpgrade = {
    enable = true;
    flake = "github:drupol/nixos-x260";
    allowReboot = true;
  };

  hardware.enableRedistributableFirmware = true;

  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.dnsname.enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      extraPackages = [ pkgs.netavark ];
    };
  };

  virtualisation.oci-containers.containers = {
    pihole = {
      image = "pihole/pihole:latest";
      ports = [
        "53:53"
        "67:67"
        "80:80"
      ];
      environment = {
        TZ = "Europe/Brussels";
      };
      volumes = [
        "pihole:/etc/pihole"
        "dnsmasq:/etc/dnsmasq.d"
      ];
    };
  };
}
