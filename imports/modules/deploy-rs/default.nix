{
  inputs,
  lib,
  config,
  ...
}:
{
  flake = {
    deploy.nodes = lib.pipe (config.unify.hosts or { }) [
      (lib.mapAttrs (
        hostname: hostConfig:
        let
          system = inputs.self.nixosConfigurations.${hostname}.config.nixpkgs.hostPlatform.system;
        in
        {
          inherit hostname;
          fastConnection = false;
          profiles.system = {
            user = "root";
            sshUser = "pol";
            sshOpts = [ ];
            path = inputs.deploy-rs.lib.${system}.activate.nixos inputs.self.nixosConfigurations.${hostname};
          };
        }
      ))
    ];
  };
}
