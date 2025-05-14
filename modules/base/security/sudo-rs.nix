{
  unify.modules.base.nixos = {
    security.sudo-rs.enable = true;
    security.sudo-rs.wheelNeedsPassword = false;

    users.users.pol = {
      extraGroups = [
        "wheel"
      ];
    };
  };
}
