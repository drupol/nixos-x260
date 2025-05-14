{
  flake.modules = {
    homeManager.shell = {
      programs = {
        bottom = {
          enable = true;
        };
      };
    };
  };
}
