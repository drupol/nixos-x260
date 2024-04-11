{ config
, pkgs
, self
, hostConfig
, inputs
, ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x280
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
