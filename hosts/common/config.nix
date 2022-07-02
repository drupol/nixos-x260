{ config, pkgs, lib, ... }:

{
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    };
  };
}
