{
  unify.modules.base = {
    nixos = {
      programs.command-not-found.enable = false;
    };

    home = {
      programs.command-not-found.enable = false;
    };
  };
}
