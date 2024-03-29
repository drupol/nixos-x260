{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
    ../common/fonts.nix
    ../common/packages.nix
    ../common/packages-desktop.nix
    ../../modules/users
    ./configuration.nix
    ./home.nix
  ];
}
