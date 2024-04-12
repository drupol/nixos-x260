{ config
, lib
, pkgs
, inputs
, ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.apple-macmini-4-1
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
