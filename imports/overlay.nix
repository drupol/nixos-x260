{ inputs, ... }:

{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
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
          (final: prev: {
            pr-337948 = import inputs.nixpkgs-pr-337948 {
              inherit (final) config;
              inherit system;
            };
          })
          inputs.nur.overlay
          inputs.deploy-rs.overlays.default
          inputs.self.overlays.default
        ];
        config = { };
      };
    };
}
