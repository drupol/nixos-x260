{ config
, pkgs
, lib
, ...
}: {
  home.activation.kbuildsycoca5 = config.lib.dag.entryAnywhere ''
    echo "Running kbuildsycoca5..."
    ${pkgs.libsForQt5.kservice}/bin/kbuildsycoca5
  '';
}
