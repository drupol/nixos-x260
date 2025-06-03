{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules = config.flake.modules.homeManager;
}
