{
  flake.modules = {
    homeManager.shell = {
      programs = {
        htop = {
          enable = true;
        };
      };
    };
  };
}
