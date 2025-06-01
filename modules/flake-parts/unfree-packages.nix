{ lib, config, ... }:
{
  options.nixpkgs.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config.flake = {
    modules =
      let
        predicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
      in
      {
        nixos.base.nixpkgs.config.allowUnfreePredicate = predicate;

        homeManager.base = args: {
          nixpkgs.config = {
            allowUnfreePredicate = predicate;
          };
        };
      };

    meta.nixpkgs.allowedUnfreePackages = config.nixpkgs.allowedUnfreePackages;
  };

}
