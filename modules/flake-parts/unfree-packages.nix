{ lib, config, ... }:
{
  options.nixpkgs.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config = {
    unify.modules =
      let
        predicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
      in
      {
        base.nixos.nixpkgs.config.allowUnfreePredicate = predicate;

        base.home = args: {
          nixpkgs.config = {
            allowUnfreePredicate = predicate;
          };
        };
      };

    flake.meta.nixpkgs.allowedUnfreePackages = config.nixpkgs.allowedUnfreePackages;
  };

}
