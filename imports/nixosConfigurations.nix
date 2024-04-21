{ inputs, self, ... }: {
  flake = {
    nixosConfigurations = inputs.nixpkgs.lib.foldr
      (hostConfig: acc: acc // {
        "${hostConfig.instance}" = inputs.nixpkgs.lib.nixosSystem {
          inherit (hostConfig) system;

          specialArgs = {
            inherit self inputs hostConfig;
          };

          modules = (self.lib.overlays hostConfig.system) ++ [
            inputs.home-manager.nixosModules.home-manager
            inputs.nur.nixosModules.nur
            # Load the modules
            ../modules/users
            # Default configuration
            ../hosts/common/configuration.nix
            ../hosts/common/tailscale.nix
            ../modules/users
            # Host specific configuration
            ../hosts/${hostConfig.hostname}
            # Host specific hardware configuration
            # ../hosts/${hostname}/hardware-configuration.nix
          ];
        };
      })
      { }
      (inputs.nixpkgs.lib.filter (el: el.operating-system == "nixos") (import ../hosts.nix));
  };
}
