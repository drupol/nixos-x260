{
  flake.modules = {
    homeManager.shell = {
      programs = {
        command-not-found = {
          enable = false;
        };
      };
    };
  };
}
