{ config, pkgs, lib, ... }:

let
  gitClone = { source, path }: lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -d "${path}" ]]; then
      ${pkgs.git}/bin/git clone ${source} ${path}
    fi

    if [ -z "$(${pkgs.git}/bin/git --git-dir=${path}/.git --work-tree=${path} status --porcelain)" ]; then
      ${pkgs.git}/bin/git --git-dir=${path}/.git --work-tree=${path} pull
    fi
  '';
in
{
  # home.activation.initPasswordStore = gitClone {
  #   source = "git@github.com:drupol/pass.git";
  #   path = "${config.xdg.configHome}/.password-store/";
  # };

  # home.activation.initWebsite = gitClone {
  #   source = "git@github.com:drupol/not-a-number.io.git";
  #   path = "${config.home.homeDirectory}/Code/drupol/not-a-number.io/";
  # };

  home.activation.profile-report-changes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
    nvd diff $(ls -dv /nix/var/nix/profiles/per-user/${config.home.username}/home-manager-*-link | tail -2)
  '';
}
