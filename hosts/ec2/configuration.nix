# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, nixos-hardware, modulesPath, ... }:

{
  imports =
    [
      "${modulesPath}/virtualisation/amazon-image.nix"
      ./hardware.nix
      ./packages.nix
    ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.grub.useOSProber = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  ec2.hvm = true;

  networking.hostName = "ec2"; # Define your hostname.
  networking.networkmanager.enable = true; # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eth0.useDHCP = true;

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

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.udisks2.enable = lib.mkForce false;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";

  fonts.fonts = with pkgs; [
    jetbrains-mono
    hack-font
    # noto-fonts
    # noto-fonts-cjk
    # noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
  ];

  # Configure keymap in X11
  services.xserver.layout = "gb";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;
  #hardware.pulseaudio.package = pkgs.pulseaudioFull;

  security.rtkit.enable = true;

  services.fstrim.enable = true;

  #  boot.extraModprobeConfig = ''
  #    options snd_hda_intel enable=0,1
  #  '';

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pol = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "docker"
      "sound"
      "video"
      "networkmanager"
      "input"
      "tty"
      "adbusers"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfxTd6cA45DZPJsk3TmFmRPu1NQQ0XX0kow18mqFsLLaxiUQX1gsfW1kTVRGNh4s77StdsmnU/5oSQEXE6D8p3uEWCwNL74Sf4Lz4UyzSrsjyEEhNTQJromlgrVkf7N3wvEOakSZJICcpl05Z3UeResnkuZGSQ6zDVAKcB3KP1uYbR4SQGmWLHI1meznRkTDM5wHoiyWJnGpQjYVsRZT4LTUJwfhildAOx6ZIZUTsJrl35L2S81E6bv696CVGPvxV+PGbwGTavMYXfrSW4pqCnDPhQCLElQS4Od1qMicfYRSmk/W2oAKb8HZwFoWQSFUStF8ldQRnPyn2wiBQnhxnczt2jUhq1Uj6Nkq/edb1Ywgn7jlBR4BgRLD3K3oMvzJ/d3xDHjU56jc5lCA6lFLDMBV6Q9DKzMwL2jG3aQbehbUwTz7zbUwAHlCFIY5HGs4d9veXHyCsUikCLPvHL/hQU/vFRHHB7WNEyQJZK+ieOAW+un+1eF88iyKsOXE9y8PjLvXYcPHdzGaQKnqzEJSQcTUw9QSzOZQQpmpy8z6Lf08D2I4GHq1REp6d4krJOOW0gXadjsGEhLqQqWGnHE47QBPnlHlDWzOaf3UX59rFsl8xZDXoXzzwJ1stpeJx+Tn/uSNnaf44yXFyeFK/IDUeOrXYD4fSTLP1P/lCFCfeYqw== (none)"
    ];

  };
  users.users.root.shell = pkgs.fish;
  security.sudo.wheelNeedsPassword = false; # Use 'sudo' without a password
  services.openssh.passwordAuthentication = false;

  nixpkgs = {
    config = {
      allowUnfree = true;
      firefox = {
        enablePlasmaBrowserIntegration = true;
      };
    };
  };
  powerManagement.enable = true;

  programs = {
    browserpass = {
      enable = true;
    };
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    fish = {
      enable = true;
      promptInit = ''
        any-nix-shell fish --info-right | source
      '';
      shellAliases = {
        cat = "bat";
        ls = "exa";
      };
    };
    adb = {
      enable = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:
  services.cron = {
    enable = false;
    systemCronJobs = [
      #"0 * * * *      root    nix-channel --update"
    ];
  };
  # Enable the OpenSSH daemon.
  # services.openssh.enable = false;

  # networking.firewall.allowedTCPPorts = [ 3389 ];
  # networking.firewall.checkReversePath = false;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  system.autoUpgrade = {
    enable = false;
    allowReboot = false;
  };

  environment.etc."current-system-packages".text = with lib;
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
    formatted;

  #  system.copySystemConfiguration = true;

  services.fwupd.enable = true;

  virtualisation.docker.enable = true;

  hardware.bluetooth.enable = true;

  # services.flatpak.enable = true;

  # networking.resolvconf.dnsExtensionMechanism = false;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    settings = {
      trusted-users = [ "root" "pol" ];
      auto-optimise-store = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

}
