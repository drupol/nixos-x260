{ inputs, lib, ... }:
{

  perSystem =
    { config, pkgs, ... }:
    {
      packages =
        let
          scope = lib.makeScope pkgs.newScope (self: {
            inherit inputs;
          });
        in
        lib.filesystem.packagesFromDirectoryRecursive {
          inherit (scope) callPackage;
          directory = ../pkgs/by-name;
        };

      overlayAttrs = config.packages;
    };
}
