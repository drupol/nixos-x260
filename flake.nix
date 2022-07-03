{
  description = "A NixOS flake for Pol's personal computer.";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Fish theme
    bobthefish = { url = "github:oh-my-fish/theme-bobthefish"; flake = false; };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@inputs: {
    homeConfigurations.devlin =
      let
        overlay-unstable = final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (final) config;
            system = "x86_64-linux";
          };
        };
        bobthefish-src = finel: prev: {
          bobthefish-src = inputs.bobthefish;
        };
      in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ overlay-unstable bobthefish-src ];
            config = {
              allowUnfreePredicate = (pkg: true);
            };
          };
          modules = [
            ./hosts/common/home.nix
            ./hosts/common/packages-hm.nix
            ./hosts/lw196205087/packages-desktop-hm.nix
            {
              home = {
                  username = "devlin";
                  homeDirectory = "/home/devlin";
                  stateVersion = "22.05";
                };
            }
            {
              xdg.enable = true;
              xdg.mime.enable = true;
              targets.genericLinux.enable = true;
            }
            ./hosts/lw196205087/activation.nix
          ];
        };

    nixosConfigurations = {
      x260 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ nixpkgs.overlays = [ (final: prev: { bobthefish-src = inputs.bobthefish; }) ]; })
          (import ./hosts/common/config.nix)
          (import ./hosts/x260/configuration.nix)
          (import ./hosts/common/packages.nix)
          (import ./hosts/common/packages-desktop.nix)
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pol.imports = [
              ./hosts/common/home.nix { home.stateVersion = "22.05"; }
            ];
          }
        ];
        specialArgs = inputs;
      };

      ec2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ nixpkgs.overlays = [ (final: prev: { bobthefish-src = inputs.bobthefish; }) ]; })
          (import ./hosts/common/config.nix)
          (import ./hosts/ec2/configuration.nix)
          (import ./hosts/common/packages.nix)
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pol.imports = [
              ./hosts/common/home.nix { home.stateVersion = "22.05"; }
            ];
          }
        ];
        specialArgs = inputs;
      };

      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ nixpkgs.overlays = [ (final: prev: { bobthefish-src = inputs.bobthefish; }) ]; })
          (import ./hosts/common/config.nix)
          (import ./hosts/nixos/configuration.nix)
          (import ./hosts/common/packages.nix)
          (import ./hosts/common/packages-desktop.nix)
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pol.imports = [
              ./hosts/common/home.nix { home.stateVersion = "22.05"; }
            ];
          }
        ];
        specialArgs = inputs;
      };

      elitebook820 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ nixpkgs.overlays = [ (final: prev: { bobthefish-src = inputs.bobthefish; }) ]; })
          (import ./hosts/common/config.nix)
          (import ./hosts/elitebook820/configuration.nix)
          (import ./hosts/common/packages.nix)
          (import ./hosts/common/packages-desktop.nix)
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pol.imports = [
              ./hosts/common/home.nix { home.stateVersion = "22.05"; }
            ];
          }
        ];
        specialArgs = inputs;
      };
    };
  } // inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ nixpkgs-fmt nixfmt ];
        };
      }
    );
}
