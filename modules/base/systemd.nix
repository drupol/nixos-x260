{
  flake.modules = {
    nixos.base = {
      systemd.services.NetworkManager-wait-online.enable = false;
    };
  };
}
