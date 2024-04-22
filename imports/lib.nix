{ inputs, lib, ... }:
{
  flake = {
    lib = {
      overlays = system: [
        (
          { config, ... }:
          {
            nixpkgs.overlays = [
              (final: prev: {
                master = import inputs.nixpkgs-master {
                  inherit (final) config;
                  inherit system;
                };
              })
              (final: prev: {
                unstable = import inputs.nixpkgs-unstable {
                  inherit (final) config;
                  inherit system;
                };
              })
              inputs.nur.overlay
            ];
          }
        )
      ];
      # Proudly found here: https://github.com/yunfachi/nypkgs/blob/master/lib/umport.nix
      umport =
        {
          path ? null,
          paths ? [ ],
          include ? [ ],
          exclude ? [ ],
          recursive ? true,
        }:
        with lib;
        with fileset;
        let
          excludedFiles = filter (path: pathIsRegularFile path) exclude;
          excludedDirs = filter (path: pathIsDirectory path) exclude;
          isExcluded =
            path:
            if elem path excludedFiles then
              true
            else
              (filter (excludedDir: lib.path.hasPrefix excludedDir path) excludedDirs) != [ ];
        in
        unique (
          (filter
            (file: pathIsRegularFile file && hasSuffix ".nix" (builtins.toString file) && !isExcluded file)
            (
              concatMap (
                _path:
                if recursive then
                  toList _path
                else
                  mapAttrsToList (
                    name: type: _path + (if type == "directory" then "/${name}/default.nix" else "/${name}")
                  ) (if excludeDotPaths then removeDotPaths (builtins.readDir _path) else builtins.readDir _path)
              ) (unique (if path == null then paths else [ path ] ++ paths))
            )
          )
          ++ (if recursive then concatMap (path: toList path) (unique include) else unique include)
        );
    };
  };
}
