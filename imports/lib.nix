{ lib, ... }:
{
  flake = {
    lib = {
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

      mkChromiumApp =
        pkgs: args:
        (pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "chromium-app-${args.appName}";
          version = "1.0.0";

          buildInputs = [ pkgs.chromium ];

          nativeBuildInputs = [
            pkgs.makeBinaryWrapper
            pkgs.copyDesktopItems
          ];

          dontUnpack = true;
          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall
            makeWrapper ${lib.getExe pkgs.chromium} $out/bin/${args.appName} \
              --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,WebUIDarkMode" \
              --add-flags "--ozone-platform-hint=auto" \
              --add-flags "--disable-sync-preferences" \
              --add-flags "--app=${args.url}"
            runHook postInstall
          '';

          desktopItems = [
            (pkgs.makeDesktopItem {
              name = args.appName;
              exec = args.appName;
              icon = args.icon or args.appName;
              desktopName = args.desktopName or args.appName;
              genericName = args.genericName or args.appName;
              categories = args.categories or [ ];
              startupWMClass = args.class or args.appName;
            })
          ];
        })).overrideAttrs
          (args);
    };
  };
}
