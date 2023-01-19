{
  description = "A flake for computers at home.";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    plasma-manager.url = "github:pjones/plasma-manager";
    nur.url = "github:nix-community/NUR";

    # Fish themes
    bobthefish = {
      url = "github:oh-my-fish/theme-bobthefish";
      flake = false;
    };

    # Fish plugins
    z = {
      url = "github:jethrokuan/z";
      flake = false;
    };
  };

  outputs = inputs: let
    # This is the same as "lib = nixpkgs.lib";
    inherit (inputs.nixpkgs) lib;

    hosts = import ./hosts.nix;

    overlays = [
      (final: prev: {
        master = import inputs.nixpkgs-master {
          inherit (final) config;
          system = "${prev.system}";
        };
      })
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final) config;
          system = "${prev.system}";
        };
      })
      (final: prev: {bobthefish-src = inputs.bobthefish;})
      (final: prev: {z-src = inputs.z;})
      inputs.nur.overlay
    ];

    mkHomeConfig = host: let
      pkgs = import inputs.nixpkgs {
        inherit overlays;
        system = host.system;
        config = {allowUnfreePredicate = pkg: true;};
      };
    in {
      "${host.user}" = inputs.home-manager.lib.homeManagerConfiguration {
        modules = [
          ./hosts/${host.instance}
        ];
        extraSpecialArgs = {
          inherit host pkgs;
          inherit (inputs) self;
        };
      };
    };

    mkConfig = host: let
      pkgs = import inputs.nixpkgs {
        inherit overlays;
        system = host.system;
        config = {allowUnfreePredicate = pkg: true;};
      };
    in {
      "${host.instance}" = inputs.nixpkgs.lib.nixosSystem {
        system = host.system;
        modules = [./hosts/${host.instance}];
        specialArgs = {
          inherit host pkgs;
          inherit (inputs) self;
        };
      };
    };
  in
    {
      homeConfigurations =
        lib.foldr (el: acc: acc // mkHomeConfig el) {}
        (lib.filter (el: el.operating-system != "nixos") hosts);
      nixosConfigurations =
        lib.foldr (el: acc: acc // mkConfig el) {}
        (lib.filter (el: el.operating-system == "nixos") hosts);
    }
    // inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {allowUnfreePredicate = pkg: true;};
      };
    in {formatter = pkgs.alejandra;});
}
