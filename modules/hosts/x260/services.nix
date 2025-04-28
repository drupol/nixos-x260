{
  flake.modules = {
    nixos.x260 = {
      services = {
        xserver = {
          xkb = {
            layout = "be";
          };
        };
        thermald.enable = true;
        avahi.enable = true;
      };
    };
  };
}
