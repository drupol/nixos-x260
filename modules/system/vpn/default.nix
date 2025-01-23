{ config, lib, pkgs, ... }:
let
  cfg = config.vpn;
in
{
  options = {
    vpn.enable = lib.mkEnableOption "vpn";
  };

  config = lib.mkIf cfg.enable {
    services.netbird = {
      enable = true;
    };

    environment.systemPackages = [
      pkgs.netbird-ui
    ];
  };
}
