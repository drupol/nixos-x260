{ config
, pkgs
, lib
, ...
}:
let
  gitClone =
    { source
    , path
    ,
    }:
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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

  home.activation.profile-report-changes = config.lib.dag.entryAnywhere ''
    ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff $oldGenPath $newGenPath
  '';
}
