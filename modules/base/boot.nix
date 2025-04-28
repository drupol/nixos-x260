{
  flake.modules = {
    nixos.base = {
      boot = {
        tmp = {
          useTmpfs = true;
          cleanOnBoot = true;
        };
      };
    };
  };
}
