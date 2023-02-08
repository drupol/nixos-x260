{inputs, ...}: let
  inherit (inputs) self;
in {
  mkHomeConfig = host: {
    "${host.user}" = inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        ({config, ...}: {
          nixpkgs.overlays = [
            (final: prev: {
              master = import inputs.nixpkgs-master {
                inherit (final) config;
                system = host.system;
              };
            })
            (final: prev: {
              unstable = import inputs.nixpkgs-unstable {
                inherit (final) config;
                system = host.system;
              };
            })
            (final: prev: {bobthefish-src = inputs.bobthefish;})
            (final: prev: {z-src = inputs.z;})
            inputs.nur.overlay
          ];
        })
        ./hosts/${host.instance}
      ];
    };
  };

  mkNixosSystem = host: {
    "${host.instance}" = inputs.nixpkgs.lib.nixosSystem {
      inherit (host) system;

      specialArgs = {
        inherit self inputs host;
      };

      modules = [
        ({config, ...}: {
          nixpkgs.overlays = [
            (final: prev: {
              master = import inputs.nixpkgs-master {
                inherit (final) config;
                system = host.system;
              };
            })
            (final: prev: {
              unstable = import inputs.nixpkgs-unstable {
                inherit (final) config;
                system = host.system;
              };
            })
            (final: prev: {bobthefish-src = inputs.bobthefish;})
            (final: prev: {z-src = inputs.z;})
            inputs.nur.overlay
          ];
        })
        inputs.home-manager.nixosModules.home-manager
        inputs.nur.nixosModules.nur

        # # auto import all nix code from `./modules`, treat each one as a flake and merge them
        # imports =
        #   map (m: "${./.}/nix/modules/${m}")
        #   (builtins.attrNames (builtins.readDir ./nix/modules));

        # Load the modules
        ../modules
        # Default configuration
        ../hosts/common/configuration.nix
        ../hosts/common/tailscale.nix
        ../modules/users
        # Host specific configuration
        ../hosts/${host.hostname}
        # Host specific hardware configuration
        # ../hosts/${hostname}/hardware-configuration.nix
      ];
    };
  };
}
