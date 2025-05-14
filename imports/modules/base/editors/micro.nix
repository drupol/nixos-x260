{
  unify.modules.base.nixos = {
    environment.variables = {
      EDITOR = "micro";
      VISUAL = "micro";
    };
  };

  unify.modules.base.home = {
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
}
