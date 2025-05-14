{
  config,
  lib,
  ...
}:
{
  flake.nixosModules = lib.mapAttrs (_: module: module.nixos) config.unify.modules;
}
