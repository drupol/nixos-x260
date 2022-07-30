{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./activation.nix
    ./packages-desktop-hm.nix
  ];
}
