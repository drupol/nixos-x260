{ config
, pkgs
, self
, hostConfig
, ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${hostConfig.user}".imports = [
      ../common/starship.nix
      {
        home.file = {
          ".config/fish/conf.d/custom.fish" = {
            source = ./. + "/../../files/home/pol/.config/fish/conf.d/custom.fish";
            recursive = true;
          };
        };
      }
      {
        home.stateVersion = "23.05";

        programs = {
          bat = { enable = true; };
          command-not-found = { enable = false; };
          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };
          eza = { enable = true; };
          fish = {
            enable = true;
            plugins = [
              {
                name = "autopair";
                inherit (pkgs.fishPlugins.autopair) src;
              }
            ];
            shellAliases = {
              ".." = "cd ..";
              "..." = "cd ../..";
              ll = "eza -lha";
              cat = "bat";
              ls = "eza";
              grep = "rg";
              man = "batman";
            };
          };
          home-manager = { enable = true; };
          htop = { enable = true; };
          zoxide = {
            enable = true;
            enableFishIntegration = true;
          };
        };
      }
    ];
  };
}
