{
  flake.modules = {
    homeManager.shell = {
      programs = {
        fzf = {
          enable = true;
        };
      };
    };
  };
}
