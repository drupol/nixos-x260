{
  description = "My Nix infrastructure at home";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:pjones/plasma-manager";
    nur.url = "github:nix-community/NUR";
    guacamole-nixos.url = "github:jbuchermn/guacamole-nixos";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs =
    { self
    , flake-parts
    , ...
    } @ inputs:
    let
      hosts = import ./hosts.nix;
      myLib = import ./lib/default.nix {
        inherit inputs;
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem =
        { self'
        , inputs'
        , pkgs
        , system
        , ...
        }: {
          formatter = pkgs.nixpkgs-fmt;

          devShells = {
            default = pkgs.mkShellNoCC {
              nativeBuildInputs = [
                pkgs.deploy-rs
              ];
            };
          };
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
