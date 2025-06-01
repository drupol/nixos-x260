{
  flake.modules = {
    nixos.base = {
      programs.command-not-found.enable = false;
    };

    homeManager.base = {
      programs.command-not-found.enable = false;
    };
  };
}
