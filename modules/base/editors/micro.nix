{
  flake.modules = {
    nixos.base = {
      environment.variables = {
        EDITOR = "micro";
        VISUAL = "micro";
      };
    };

    homeManager.base = {
      programs = {
        micro = {
          enable = true;
          settings = {
            diffgutter = true;
            keymenu = true;
            mkparents = true;
            tabsize = 2;
            tabstospaces = true;
          };
        };
      };
    };
  };
}
