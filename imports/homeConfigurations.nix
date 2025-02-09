{
  inputs,
  self,
  lib,
  ...
}:
{
  flake = {
    homeConfigurations =
      let
        isImpure = builtins ? currentSystem;
        # This is why we have to use --impure flag.
        usernameEnvVar = builtins.getEnv "USER";
        homeEnvVar = builtins.getEnv "HOME";
        # End of impure part.

        # If the user cannot be found, we cannot continue.
        username =
          if "" == usernameEnvVar then throw "Unable to detect username, aborting." else usernameEnvVar;
        # If the home directory cannot be found, we cannot continue.
        homeDirectory =
          if "" == homeEnvVar then throw "Unable to detect user home directory, aborting." else homeEnvVar;

        profiles = inputs.nixpkgs.lib.foldr (
          hostConfig: acc:
          acc
          // {
            "${hostConfig.instance}-${username}" = inputs.home-manager.lib.homeManagerConfiguration {
              inherit (hostConfig) system;
              pkgs = import inputs.nixpkgs { };
              extraSpecialArgs = {
                system = if hostConfig.system != "" then hostConfig.system else builtins.currentSystem;
                inherit inputs self username homeDirectory;
              };

              modules = lib.optionals (lib.pathExists ./../hosts/${hostConfig.hostname}/home) [
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
                    extraSpecialArgs = {
                      inherit hostConfig inputs self;
                    };
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
        ) { } (import ../hosts.nix);
      in
      if false == isImpure then
        throw "This home manager profile requires the use of the `--impure` flag. Please refer to the documentation at https://code.europa.eu/ecphp/devs-profile#note-about-impure-flag to learn more about this requirement."
      else
        profiles;

  };
}
