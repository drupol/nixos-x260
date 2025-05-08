{
  flake.modules = {
    homeManager.shell = {
      programs = {
        eza = {
          enable = true;
        };
      };
    };
  };
}
