{
  flake.modules = {
    nixos.base = {
      programs.command-not-found.enable = false;
    };
  };
}
