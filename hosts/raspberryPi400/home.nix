{
  config,
  pkgs,
  self,
  host,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${host.user}".imports = [
      {
        home.stateVersion = "23.05";

        programs = {
          bat = {enable = true;};
          command-not-found = {enable = false;};
          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };
          exa = {enable = true;};
          fish = {
            enable = true;
            interactiveShellInit = ''
              ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
              set fish_theme nord
              set -gx EDITOR nano
            '';
            plugins = [
              {
                name = "tide";
                inherit (pkgs.fishPlugins.tide) src;
              }
              {
                name = "z";
                src = pkgs.z-src;
              }
            ];
            shellAliases = {
              ".." = "cd ..";
              "..." = "cd ../..";
              ll = "exa -lha";
              cat = "bat";
              ls = "exa";
              grep = "rg";
              man = "batman";
            };
          };
          home-manager = {enable = true;};
          htop = {enable = true;};
        };
      }
    ];
  };
}
