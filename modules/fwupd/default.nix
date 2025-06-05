{
  flake.modules.nixos.fwupd = {
    services = {
      fwupd = {
        enable = true;
      };
    };
  };
}
