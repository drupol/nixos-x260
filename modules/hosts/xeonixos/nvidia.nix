{ lib, ... }:
{
  flake.modules.nixos."hosts/xeonixos" =
    { config, pkgs, ... }:
    {
      hardware.nvidia.open = false;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

      nixpkgs.config.nvidia.acceptLicense = true;
    };

  nixpkgs.allowedUnfreePackages = [
    "nvidia-x11-390"
    "nvidia-x11"
    "nvidia-settings"
  ];
}
