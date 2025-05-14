{
  flake.modules = {
    homeManager.shell = {
      programs = {
        ripgrep = {
          enable = true;
        };
      };
    };
  };
}
