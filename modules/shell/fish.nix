{
  flake.modules = {
    nixos.shell = {
      programs.fish.enable = true;
    };

    homeManager.shell =
      { pkgs, ... }:
      {
        home.shell.enableFishIntegration = true;

        programs = {
          fish = {
            enable = true;
            plugins = [
              {
                name = "autopair";
                src = pkgs.fishPlugins.autopair;
              }
            ];
            shellAliases = {
              ".." = "cd ..";
              "..." = "cd ../..";
              cat = "bat";
              ls = "eza";
              grep = "rg";
            };
            functions = {
              fish_greeting = "";
            };
          };
        };
      };
  };
}
