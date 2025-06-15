{
  inputs,
  lib,
  config,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      make-shells.default = {
        packages = [
          pkgs.deploy-rs
        ];
      };
    };

  flake =
    let
      prefix = "hosts/";
    in
    {
      deploy.nodes = lib.pipe (config.flake.modules.nixos) [
        (lib.filterAttrs (name: _: lib.hasPrefix prefix name))
        (lib.mapAttrs' (
          name: module:
          let
            hostname = lib.removePrefix prefix name;
            system = inputs.self.nixosConfigurations.${hostname}.config.nixpkgs.hostPlatform.system;
          in
          {
            name = hostname;
            value = {
              inherit hostname;
              fastConnection = false;
              profiles.system = {
                user = "root";
                sshUser = "pol";
                sshOpts = [ ];
                path = inputs.deploy-rs.lib.${system}.activate.nixos inputs.self.nixosConfigurations.${hostname};
              };
            };
          }
        ))
      ];
    };
}
