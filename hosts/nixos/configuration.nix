{ config
, pkgs
, lib
, inputs
, ...
}: {
  disabledModules = [ "services/web-apps/code-server.nix" "services/web-apps/openvscode-server.nix" ];

  imports = [
    ./hardware-configuration.nix
    "${inputs.nixpkgs-master}/nixos/modules/services/web-apps/code-server.nix"
    "${inputs.nixpkgs-master}/nixos/modules/services/web-apps/openvscode-server.nix"
    "${inputs.guacamole-nixos}/nixos/modules/services/web-apps/guacamole.nix"
    ./code.nix
    ./caddy.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
  console.useXkbConfig = true;

  # Limit the systemd journal to 100 MB of disk or the
  # last 7 days of logs, whichever happens first.
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=5day
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
        plasma5 = {
          enable = true;
        };
      };
      displayManager = {
        sddm = {
          enable = true;
        };
      };
      layout = "us";
      xkbOptions = "eurosign:e";
    };
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;
  #hardware.pulseaudio.package = pkgs.pulseaudioFull;

  security.rtkit.enable = true;

  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=0,1
  '';

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  security.sudo.wheelNeedsPassword = false; # Use 'sudo' without a password

  powerManagement.enable = true;

  programs.ssh.forwardX11 = true;

  # networking.firewall.allowedTCPPorts = [
  #   80
  #   443
  # ];
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = lib.mkForce false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  system.autoUpgrade = {
    enable = true;
    flake = "github:drupol/nixos-x260";
    allowReboot = true;
  };

  services.guacamole.enable = true;
}
