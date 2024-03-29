{ inputs, ... }:
let
  inherit (inputs) self;
in
{
  mkHomeConfig = hostConfig: {
    "${hostConfig.user}" = inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        ({ config, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              master = import inputs.nixpkgs-master {
                inherit (final) config;
                system = hostConfig.system;
              };
            })
            (final: prev: {
              unstable = import inputs.nixpkgs-unstable {
                inherit (final) config;
                system = hostConfig.system;
              };
            })
            inputs.nur.overlay
            inputs.deploy-rs.overlay
          ];
        })
        ./hosts/${hostConfig.instance}
      ];
    };
  };

  mkNixosSystem = hostConfig: {
    "${hostConfig.instance}" = inputs.nixpkgs.lib.nixosSystem {
      inherit (hostConfig) system;

      specialArgs = {
        inherit self inputs hostConfig;
      };

      modules = [
        ({ config, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              master = import inputs.nixpkgs-master {
                inherit (final) config;
                system = hostConfig.system;
              };
            })
            (final: prev: {
              unstable = import inputs.nixpkgs-unstable {
                inherit (final) config;
                system = hostConfig.system;
              };
            })
            inputs.nur.overlay
            inputs.deploy-rs.overlay
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
        ../hosts/${hostConfig.hostname}
        # Host specific hardware configuration
        # ../hosts/${hostname}/hardware-configuration.nix
      ];
    };
  };

  mkNode =
    { instance
    , hostname
    , domain ? hostname
    , system ? "x86_64-linux"
    , sshIdentityFile
    , remoteBuild ? false
    , ...
    }: {
      "${instance}" = {
        inherit hostname;
        fastConnection = false;
        profiles.system = {
          inherit remoteBuild;
          user = "root";
          sshUser = "pol";
          sshOpts = [ ];
          path = inputs.deploy-rs.lib.${system}.activate.nixos inputs.self.nixosConfigurations.${instance};
        };
      };
    };
}
