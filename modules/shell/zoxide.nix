{
  flake.modules = {
    homeManager.shell = {
      programs = {
        zoxide = {
          enable = true;
          enableFishIntegration = true;
        };
      };
    };
  };
}
