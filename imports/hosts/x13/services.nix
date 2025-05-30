{
  unify.hosts.nixos.x13.nixos = {
    services = {
      xserver = {
        xkb = {
          layout = "gb";
        };
      };
      thermald.enable = true;
      avahi.enable = true;
    };
  };
}
