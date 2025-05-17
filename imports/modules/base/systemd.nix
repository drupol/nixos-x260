{
  unify.modules.base.nixos = {
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
