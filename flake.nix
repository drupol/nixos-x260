{
  description = "A NixOS flake for Pol's personal computer.";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Fish theme
    bobthefish = { url = "github:oh-my-fish/theme-bobthefish"; flake = false; };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@inputs: {

    nixosConfigurations = {
      x260 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ nixpkgs.overlays = [ (final: prev: { bobthefish-src = inputs.bobthefish; }) ]; })
          (import ./hosts/x260/configuration.nix)
          (import ./hosts/common/packages.nix)
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pol = import ./hosts/common/home.nix;
          }
        ];
        specialArgs = inputs;
      };

      ec2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ nixpkgs.overlays = [ (final: prev: { bobthefish-src = inputs.bobthefish; }) ]; })
          (import ./hosts/ec2/configuration.nix)
          (import ./hosts/common/packages.nix)
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pol = import ./hosts/common/home.nix;
          }
        ];
        specialArgs = inputs;
      };

      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ nixpkgs.overlays = [ (final: prev: { bobthefish-src = inputs.bobthefish; }) ]; })
          (import ./hosts/nixos/configuration.nix)
          (import ./hosts/common/packages.nix)
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pol = import ./hosts/common/home.nix;
          }
        ];
        specialArgs = inputs;
      };

      elitebook820 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ nixpkgs.overlays = [ (final: prev: { bobthefish-src = inputs.bobthefish; }) ]; })
          (import ./hosts/elitebook820/configuration.nix)
          (import ./hosts/common/packages.nix)
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pol = import ./hosts/common/home.nix;
          }
        ];
        specialArgs = inputs;
      };
    };
  };
}
