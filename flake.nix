{
  description = "My Nix infrastructure at home";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:/nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:pjones/plasma-manager/56c325e68d69b9682bcb1be99650b6c28bedb93d";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs@{ self, flake-parts, nixpkgs, nixpkgs-master, home-manager, deploy-rs, systems, ... }:
    let
      hosts = import ./hosts.nix;
      myLib = import ./lib/default.nix {
        inherit inputs;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        formatter = pkgs.nixpkgs-fmt;

        devShells = {
          default = pkgs.mkShellNoCC {
            buildInputs = [
              pkgs.deploy-rs
              pkgs.nixpkgs-fmt
            ];
          };
        };

        checks = deploy-rs.lib.${system}.deployChecks { nodes = (inputs.nixpkgs.lib.foldr (el: acc: acc // myLib.mkNode el) { } (builtins.filter (el: el.system == "x86_64-linux") hosts)); };
      };

      flake = {
        # homeConfigurations =
        #   inputs.nixpkgs.lib.foldr (el: acc: acc // myLib.mkHomeConfig el) {}
        #   (inputs.nixpkgs.lib.filter (el: el.operating-system != "nixos") hosts);

        nixosConfigurations =
          inputs.nixpkgs.lib.foldr (el: acc: acc // myLib.mkNixosSystem el) { }
            (inputs.nixpkgs.lib.filter (el: el.operating-system == "nixos") hosts);

        deploy.nodes = inputs.nixpkgs.lib.foldr (el: acc: acc // myLib.mkNode el) { } hosts;
      };
    };
}
