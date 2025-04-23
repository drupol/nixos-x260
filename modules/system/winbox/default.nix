{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.winbox;
in
{
  options = {
    winbox.enable = lib.mkEnableOption "winbox";
  };

  config = lib.mkIf (cfg.enable && config.desktop.enable) {
    environment.systemPackages = with pkgs; [ winbox4 ];

    networking = {
      firewall.allowedUDPPorts = [ 5678 ];
    };
  };
}
