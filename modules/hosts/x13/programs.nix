{
  flake.modules = {
    nixos.x13 = {
      programs = {
        noisetorch = {
          enable = true;
        };
        projecteur = {
          enable = true;
        };
      };
    };
  };
}
