{ lib, ... }:
{
  vpn.enable = true;
  sshd.enable = lib.mkForce false;
}
