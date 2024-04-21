{ inputs, ... }: {
  flake = {
    deploy.nodes = inputs.nixpkgs.lib.foldr
      (config: acc: acc // {
        "${config.instance}" = {
          inherit (config) hostname;
          fastConnection = false;
          profiles.system = {
            inherit (config) remoteBuild;
            user = "root";
            sshUser = "pol";
            sshOpts = [ ];
            path = inputs.deploy-rs.lib.${config.system}.activate.nixos inputs.self.nixosConfigurations.${config.instance};
          };
        };
      })
      { }
      (import ./hosts.nix);
  };
}
