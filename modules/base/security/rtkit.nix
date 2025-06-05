{
  flake.modules.nixos.base = {
    security.rtkit.enable = true;
  };
}
