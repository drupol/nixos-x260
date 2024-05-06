{
  inputs,
  self,
  lib,
  ...
}:
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

          modules = [ inputs.lix-module.nixosModules.default ] ++
            (self.lib.overlays hostConfig.system)
            ++ (inputs.self.lib.umport {
              paths = [
                ../modules/system
                ../hosts/common/system
                (./. + "/../hosts/${hostConfig.hostname}/system")
              ];
            })
            ++ lib.optionals (lib.pathExists (./. + "/../hosts/${hostConfig.hostname}/home")) [
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
                  extraSpecialArgs = {
                    inherit hostConfig;
                  };
                  users."${hostConfig.user}".imports = inputs.self.lib.umport {
                    paths = [
                      ../modules/home
                      ../hosts/common/home
                      (./. + "/../hosts/${hostConfig.hostname}/home")
                    ];
                  };
                };
              }
            ];
        };
      }
    ) { } (inputs.nixpkgs.lib.filter (el: el.operating-system == "nixos") (import ../hosts.nix));
  };
}
