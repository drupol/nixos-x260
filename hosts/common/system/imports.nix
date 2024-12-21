{ inputs, hostConfig, ... }:
{
  imports = [
    inputs.nix-oracle-db.nixosModules.oracle-database-container
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
        inputs.nix-webapps.overlays.lib
        inputs.nur.overlays.default
        inputs.self.overlays.default
      ];
    }
  ];
}
