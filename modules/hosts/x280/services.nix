{
  unify.hosts.x280.nixos = {
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
}
