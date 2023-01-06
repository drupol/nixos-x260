{
  description = "A NixOS flake for Pol's personal computer.";

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

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    nur,
    ...
  } @ inputs: let
    # This is the same as "lib = nixpkgs.lib";
    inherit (nixpkgs) lib;

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
      (final: prev: {
        bobthefish-src = inputs.bobthefish;
      })
      (final: prev: {
        z-src = inputs.z;
      })
      nur.overlay
    ];

    pkgs = import nixpkgs {
      inherit overlays;
      system = "x86_64-linux";
      config = {
        allowUnfreePredicate = pkg: true;
      };
    };

    mkHomeConfig = {
      instance,
      hostname,
      operating-system,
      system,
      user,
      ...
    }: {
      "${user}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./hosts/${instance}
        ];
        extraSpecialArgs = {inherit inputs instance hostname operating-system system user;};
      };
    };

    mkConfig = {
      instance,
      hostname,
      operating-system,
      system,
      user,
      ...
    }: {
      "${instance}" = lib.nixosSystem {
        inherit system pkgs;
        modules = [
          (import ./hosts/common/config.nix)
          (import ./hosts/common/packages.nix)
          (import ./hosts/common/packages-desktop.nix)
          (import ./hosts/${instance}/configuration.nix)
          (import ./activation/system-report-changes.nix)
          (import ./users)
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${user}".imports = [
              inputs.plasma-manager.homeManagerModules.plasma-manager
              ./hosts/common/home.nix
              ./hosts/common/kdeplasma.nix
              ./activation/profile-report-changes.nix
              {home.stateVersion = "22.05";}
            ];
          }
        ];
        specialArgs = {inherit inputs instance hostname operating-system system user;};
      };
    };
  in
    {
      homeConfigurations = lib.foldr (el: acc: acc // mkHomeConfig el) {} (lib.filter (el: el.operating-system != "nixos") hosts);
      nixosConfigurations = lib.foldr (el: acc: acc // mkConfig el) {} (lib.filter (el: el.operating-system == "nixos") hosts);
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfreePredicate = pkg: true;
          };
        };
      in {
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.nixpkgs-fmt
            pkgs.nixfmt
          ];
        };
      }
    );
}
