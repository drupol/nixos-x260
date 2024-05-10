{
  inputs,
  lib,
  system,
  hostConfig,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      nixpkgs.overlays = [
        (final: prev: {
          master = import inputs.nixpkgs-master {
            inherit (final) config;
            inherit (hostConfig) system;
          };
        })
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (final) config;
            inherit (hostConfig) system;
          };
        })
        inputs.nur.overlay
      ];
    }
  ] ++ lib.optionals (hostConfig.instance != "router") [ inputs.lix-module.nixosModules.default ];
}
