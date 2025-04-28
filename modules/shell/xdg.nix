{
  flake.modules = {
    homeManager.shell = {
      xdg.enable = true;
      xdg.mime.enable = true;
    };
  };
}
