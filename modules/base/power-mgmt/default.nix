{ lib, ... }:
{
  flake.modules.nixos.base = {
    powerManagement = {
      enable = true;
      cpuFreqGovernor = lib.mkDefault "powersave";
    };
  };
}
