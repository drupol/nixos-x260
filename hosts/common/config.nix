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
    extraOptions = ''
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

  # TODO: investigate why this is not working when it is set in home.nix
  programs.command-not-found.enable = false;
}
