{
  description = "A NixOS flake for Pol's personal computer.";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {

    nixosConfigurations = {
      x260 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./hosts/x260/configuration.nix)
        ];
        specialArgs = inputs;
      };

      ec2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./hosts/ec2/configuration.nix)
        ];
        specialArgs = inputs;
      };
    };
  };
}
