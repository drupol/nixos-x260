{ config, pkgs, lib, ... }:

{
  home.activation.profile-report-changes = ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
    nvd diff $(ls -dv /nix/var/nix/profiles/per-user/${config.home.username}/home-manager-*-link | tail -2)
  '';
}
