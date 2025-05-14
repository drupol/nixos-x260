{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules = lib.mapAttrs (_: module: module.home) config.unify.modules;
}
