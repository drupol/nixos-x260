{ config, pkgs, lib, ... }:

{
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
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    };
  };

  # Clean tmp on reboot
  boot.cleanTmpDir = true;

  services.fstrim.enable = true;
  services.nscd.enableNsncd = true;
  # needed for store VS Code auth token
  services.gnome.gnome-keyring.enable = true;

  # TODO: investigate why this is not working when it is set in home.nix
  programs.command-not-found.enable = false;
}
