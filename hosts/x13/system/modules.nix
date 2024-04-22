{ lib, ... }:
{
  # Custom modules
  desktop.enable = true;
  sshd.enable = lib.mkForce false;
}
