{
  flake.modules.nixos.base = {
    security.sudo-rs.enable = true;
    security.sudo-rs.wheelNeedsPassword = false; # Use 'sudo' without a password
  };
}
