{ config
, lib
, pkgs
, ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.

  # services.acpid.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_BE.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
  console.useXkbConfig = true;

  # Limit the systemd journal to 100 MB of disk or the
  # last 3 days of logs, whichever happens first.
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=3day
  '';

  services = {
    flatpak = {
      enable = false;
    };
    fwupd = {
      enable = true;
    };
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      desktopManager = {
        plasma6 = {
          enable = true;
        };
      };
      displayManager = {
        sddm = {
          enable = true;
        };
      };
      xkb = {
        layout = "gb";
        options = "eurosign:e";
      };
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  security.rtkit.enable = true;

  security.sudo.wheelNeedsPassword = false; # Use 'sudo' without a password
  powerManagement.enable = true;

  # List services that you want to enable:
  # services.cron = {
  #   enable = false;
  #   systemCronJobs = [
  #     "0 * * * *      root    nix-channel --update"
  #   ];
  # };

  networking = {
    hostName = "minimac";
    networkmanager = {
      enable = true;
    };
    useDHCP = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://search.nixos.org/options?&show=system.stateVersion&from=0&size=50&sort=relevance&type=packages&query=stateVersion).
  system.stateVersion = "23.11"; # Did you read the comment?

  system.autoUpgrade = {
    enable = false;
    flake = "github:drupol/nixos-x260";
    allowReboot = true;
  };

  hardware.bluetooth.enable = true;

  services.avahi.enable = true;
}
