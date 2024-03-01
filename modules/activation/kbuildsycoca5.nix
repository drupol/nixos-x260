{ config
, pkgs
, lib
, ...
}: {
  home.activation.kbuildsycoca5 = config.lib.dag.entryAnywhere ''
    echo "Running kbuildsycoca6..."
    ${pkgs.kdePackages.kservice}/bin/kbuildsycoca6
  '';
}
