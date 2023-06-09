{ config
, pkgs
, lib
, ...
}: {
  system.activationScripts.system-report-changes = ''
    PATH=$PATH:${lib.makeBinPath [pkgs.nvd pkgs.nix]}

    # Disable nvd if there are lesser than 2 profiles in the system.
    if [ $(ls -d1v /nix/var/nix/profiles/system-*-link 2>/dev/null | wc -l) -lt 2 ];
    then
        echo "Skipping reporting changes..."
    else
        nvd diff $(ls -d1v /nix/var/nix/profiles/system-*-link | tail -2)
    fi
  '';
}
