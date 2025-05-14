{
  lib,
  config,
  ...
}:
{
  unify.modules.base =
    let
      predicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
    in
    {
      nixos = {
        nixpkgs.config.allowUnfreePredicate = predicate;
      };

      home = {
        nixpkgs.config.allowUnfreePredicate = predicate;
      };
    };
}
