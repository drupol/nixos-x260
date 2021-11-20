{
  description = "A NixOS flake for pol's personal computer.";

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
          nixos-hardware.nixosModules.lenovo-thinkpad-x260
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
