{
  flake.modules = {
    homeManager.dev = {
      programs.mergiraf = {
        enable = true;
      };
    };
  };
}
