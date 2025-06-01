{
  flake.modules = {
    hosts.x280 = {
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
