{ config
, pkgs
, inputs
, ...
}: {
  imports = [
    ./root.nix
    ./pol.nix
  ];
}
