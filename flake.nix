{
  description = "My Nix infrastructure at home";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:/nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-pr-337948.url = "github:drupol/nixpkgs/broadcom-sta/add-patches";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware-pr-1089.url = "github:drupol/nixos-hardware/add-imac-14-2";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-oracle-db.url = "github:drupol/nix-oracle-db";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
        ./imports/pkgs.nix
        ./imports/formatter.nix
        ./imports/devshells.nix
        ./imports/overlay.nix
        ./imports/nixosConfigurations.nix
        ./imports/lib.nix
        ./imports/deploy.nix
        ./imports/checks.nix
      ];
    };
}
