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
      let
        specialArgs = {
          inherit self inputs hostConfig;
        } // self.packages.${hostConfig.system};
      in
      acc
      // {
        "${hostConfig.instance}" = inputs.nixpkgs.lib.nixosSystem {
          inherit (hostConfig) system;

          inherit specialArgs;

          modules =
            [ inputs.nixos-generators.nixosModules.all-formats ]
            ++ (inputs.self.lib.umport {
              paths = [
                ../modules/system
                ../hosts/common/system
                ./../hosts/${hostConfig.hostname}/system
              ];
            })
            ++ lib.optionals (lib.pathExists ./../hosts/${hostConfig.hostname}/home) [
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
                  extraSpecialArgs = specialArgs;
                  users."${hostConfig.user}".imports = inputs.self.lib.umport {
                    paths = [
                      ../modules/home
                      ../hosts/common/home
                      ./../hosts/${hostConfig.hostname}/home
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
