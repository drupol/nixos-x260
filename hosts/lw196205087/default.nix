{ config
, pkgs
, ...
}: {
  imports = [
    ./home.nix
    ./configuration.nix
    ./packages.nix
  ];
}
