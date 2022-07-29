{ config, pkgs, lib, ... }:

{
  system.activationScripts.report-changes = ''
    ${pkgs.nix}/bin/nix profile diff-closures --profile /nix/var/nix/profiles/system
  '';
}
