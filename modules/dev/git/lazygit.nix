{
  flake.modules = {
    homeManager.dev = {
      programs = {
        lazygit = {
          enable = true;
          settings = {
            git.overrideGpg = true;
          };
        };
      };
    };
  };
}
