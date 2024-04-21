{ inputs, ... }: {
  flake = {
    lib.overlays = system: [
      ({ config, ... }: {
        nixpkgs.overlays = [
          (final: prev: {
            master = import inputs.nixpkgs-master {
              inherit (final) config;
              inherit system;
            };
          })
          (final: prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit (final) config;
              inherit system;
            };
          })
          inputs.nur.overlay
        ];
      })
    ];
  };
}
