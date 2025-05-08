{
  inputs,
  lib,
  config,
  ...
}:
{
  flake = {
    deploy.nodes =
      let
        prefix = "nixosConfigurations/";
      in
      lib.pipe (config.flake.modules.nixos or { }) [
        (lib.filterAttrs (name: _module: lib.hasPrefix prefix name))
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
