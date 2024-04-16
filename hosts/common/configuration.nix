{ config
, lib
, pkgs
, ...
}: {
  nix = {
    # From https://jackson.dev/post/nix-reasonable-defaults/
    extraOptions = ''
      connect-timeout = 5
      log-lines = 25
      min-free = 128000000
      max-free = 1000000000
      fallback = true
      warn-dirty = false
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
    # nix repl "/etc/nix/inputs/nixpkgs"
    nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
    registry = {
      nixpkgs.to = {
        type = "path";
        path = pkgs.path;
      };
    };
    settings = {
      trusted-users = [ "root" "pol" ];
      auto-optimise-store = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    };
  };

  boot = {
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernel = {
      sysctl = {
        "net.ipv4.conf.all.forwarding" = lib.mkForce true;
        "net.ipv6.conf.all.forwarding" = lib.mkForce true;
      };
    };
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_BE.UTF-8";
    LC_IDENTIFICATION = "fr_BE.UTF-8";
    LC_MEASUREMENT = "fr_BE.UTF-8";
    LC_MONETARY = "fr_BE.UTF-8";
    LC_NAME = "fr_BE.UTF-8";
    LC_NUMERIC = "fr_BE.UTF-8";
    LC_PAPER = "fr_BE.UTF-8";
    LC_TELEPHONE = "fr_BE.UTF-8";
    LC_TIME = "fr_BE.UTF-8";
  };

  services.fstrim.enable = true;
  services.nscd.enableNsncd = true;
  # needed for store VS Code auth token
  services.gnome.gnome-keyring.enable = true;

  # TODO: investigate why this is not working when it is set in home.nix
  programs.command-not-found.enable = false;
  programs.fish.enable = true;

  # https://mastodon.online/@nomeata/109915786344697931
  documentation.nixos.enable = false;

  systemd.services.NetworkManager-wait-online.enable = false;

  environment.etc."nix/inputs/nixpkgs".source = pkgs.path;

  environment.variables.EDITOR = "micro";
  environment.variables.VISUAL = "micro";
}
