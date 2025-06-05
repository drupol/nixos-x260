{
  flake.modules.nixos."hosts/x13" = {
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
