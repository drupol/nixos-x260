{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.make-shell.flakeModules.default
  ];

  flake = {
    deploy.nodes = lib.mapAttrs (
      hostname: hostConfig:
      let
        system = inputs.self.nixosConfigurations.${hostname}.config.nixpkgs.hostPlatform.system;
      in
      {
        hostname = hostConfig.fqdn;
        fastConnection = false;
        profiles.system = {
          user = "root";
          sshUser = "pol";
          sshOpts = [ ];
          path = inputs.deploy-rs.lib.${system}.activate.nixos inputs.self.nixosConfigurations.${hostname};
        };
      }
    ) config.unify.hosts;
  };

  perSystem =
    { pkgs, ... }:
    {
      make-shells.default.packages = with pkgs; [ deploy-rs ];
    };

}
