{
  flake.modules = {
    homeManager.shell = {
      programs = {
        bat = {
          enable = true;
        };
      };
    };
  };
}
