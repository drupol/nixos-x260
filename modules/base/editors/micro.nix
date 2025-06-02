{
  flake.modules = {
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

      sessionVariables = {
        EDITOR = "micro";
        VISUAL = "micro";
      };
    };
  };
}
