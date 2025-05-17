{ lib, ... }:
{
  unify.modules.base.nixos = {
    powerManagement = {
      enable = true;
      cpuFreqGovernor = lib.mkDefault "powersave";
    };
  };
}
