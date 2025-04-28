
{
  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  boot.loader.systemd-boot.enable = true;
  # boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "nodev"; # or "nodev" for efi only

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

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "be";
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
    hostName = "elitebook820";
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
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  virtualisation.docker.enable = false;

  hardware.bluetooth.enable = true;
}
