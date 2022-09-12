{ config, pkgs, lib, ... }:

{
  system.activationScripts.system-report-changes = ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}

    # Disable nvd if there are lesser than 2 profiles in the system.
    if [ `ls -d1v /nix/var/nix/profiles/system-*-link 2>/dev/null | wc -l ` -lt 2 ];
    then
        return 0
    fi

    nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
  '';
}
