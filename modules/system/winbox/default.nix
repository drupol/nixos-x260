{ config
, lib
, pkgs
, ...
}: let
  cfg = config.winbox;
in {
  options = {
    winbox.enable = lib.mkEnableOption "winbox";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      winbox
    ];
    networking = {
      firewall.allowedUDPPorts = [ 5678 ];
    };
  };
}
