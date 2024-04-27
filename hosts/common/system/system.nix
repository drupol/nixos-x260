{ ... }: {
  system.autoUpgrade = {
    enable = false;
    flake = "github:drupol/nixos-x260";
    allowReboot = true;
  };
}
