{
  flake.modules = {
    nixos.base = {
      networking = {
        networkmanager = {
          enable = true;
        };
        useDHCP = false;
      };
    };
  };
}
