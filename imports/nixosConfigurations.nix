{ inputs, self, ... }:
{
  flake = {
    nixosConfigurations = inputs.nixpkgs.lib.foldr (
      hostConfig: acc:
      acc
      // {
        "${hostConfig.instance}" = inputs.nixpkgs.lib.nixosSystem {
          inherit (hostConfig) system;

          specialArgs = {
            inherit self inputs hostConfig;
          };

          modules =
            (self.lib.overlays hostConfig.system)
            ++ (inputs.self.lib.umport { path = ../modules/system; })
            ++ (inputs.self.lib.umport { path = ../hosts/common/system; })
            ++ (inputs.self.lib.umport { path = ./. + "/../hosts/${hostConfig.hostname}/system"; })
            ++ [ inputs.home-manager.nixosModules.home-manager ]
            ++ [
              ({
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
                  extraSpecialArgs = {
                    inherit hostConfig;
                  };
                  users."${hostConfig.user}".imports =
                    [ ]
                    ++ (inputs.self.lib.umport { path = ../hosts/common/home; })
                    ++ (inputs.self.lib.umport { path = ./. + "/../hosts/${hostConfig.hostname}/home"; })
                    ++ (inputs.self.lib.umport { path = ../modules/home; });
                };
              })
            ];
        };
      }
    ) { } (inputs.nixpkgs.lib.filter (el: el.operating-system == "nixos") (import ../hosts.nix));
  };
}
