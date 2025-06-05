{
  flake.modules.nixos.base = {
    services.orca.enable = false;
    services.speechd.enable = false;
  };
}
