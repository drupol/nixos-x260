{
  inputs,
  lib,
  config,
  ...
}:
{
  flake.nixosConfigurations = lib.pipe (config.flake.modules.hosts or { }) [
    (lib.mapAttrs (
      name: module:
      let
        specialArgs = {
          inherit inputs;
          hostConfig = module // {
            name = name;
          };
        };
      in
      inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = module.imports ++ [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      }
    ))
  ];
}
