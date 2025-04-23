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
            [
              inputs.nixos-generators.nixosModules.all-formats
              (inputs.import-tree ../modules/system)
              (inputs.import-tree ../hosts/common/system)
              (inputs.import-tree ./../hosts/${hostConfig.hostname}/system)
            ]
            ++ lib.optionals (lib.pathExists ./../hosts/${hostConfig.hostname}/home) [
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
                  extraSpecialArgs = specialArgs;
                  users."${hostConfig.user}".imports = [
                    (inputs.import-tree ../modules/home)
                    (inputs.import-tree ../hosts/common/home)
                    (inputs.import-tree ./../hosts/${hostConfig.hostname}/home)
                  ];
                };
              }
            ];
        };
      }
    ) { } (inputs.nixpkgs.lib.filter (el: el.operating-system == "nixos") (import ../hosts.nix));
  };
}
