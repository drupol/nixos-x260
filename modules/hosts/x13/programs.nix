{
  flake.modules.nixos."hosts/x13" = {
    programs = {
      noisetorch = {
        enable = true;
      };
      projecteur = {
        enable = true;
      };
    };
  };
}
