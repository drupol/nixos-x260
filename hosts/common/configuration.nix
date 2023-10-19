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
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
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

  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-16.20.2"
  ];

  environment.etc."nix/inputs/nixpkgs".source = pkgs.path;
}
