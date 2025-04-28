{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.activation = {
    linkDesktopApplications = {
      after = [
        "writeBoundary"
        "createXdgUserDirectories"
      ];
      before = [ ];
      data = ''
        rm -rf ${config.xdg.dataHome}/"applications/home-manager"
        mkdir -p ${config.xdg.dataHome}/"applications/home-manager"
        cp -Lr ${config.home.homeDirectory}/.nix-profile/share/applications/* ${config.xdg.dataHome}/"applications/home-manager/"
      '';
    };
    report-changes = ''
      PATH=$PATH:${
        lib.makeBinPath [
          pkgs.nvd
          pkgs.nix
        ]
      }
      nvd diff $(ls -dv /nix/var/nix/profiles/per-user/${config.home.username}/home-manager-*-link | tail -2)
    '';
  };
}
