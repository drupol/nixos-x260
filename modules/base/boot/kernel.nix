{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
