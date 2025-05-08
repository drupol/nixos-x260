{
  flake.modules = {
    homeManager.dev = {
      programs = {
        gpg = {
          enable = true;
          settings = {
            default-key = "0AAF2901E8040715";
          };
        };
      };
    };
  };
}
