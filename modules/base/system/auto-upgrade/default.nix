{
  flake.modules.nixos.base = {
    system.autoUpgrade = {
      enable = false;
      flake = "github:drupol/infra";
      allowReboot = true;
    };
  };
}
