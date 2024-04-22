{ config, lib, ... }:
let
  cfg = config.sshd;
in
{
  options = {
    sshd.enable = lib.mkEnableOption "sshd" // {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          X11Forwarding = true;
        };
      };
    };
  };
}
