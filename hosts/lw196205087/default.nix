{ config
, pkgs
, ...
}: {
  imports = [
    ./home.nix
    ./configuration.nix
    ./activation.nix
    ./packages.nix
  ];
}
