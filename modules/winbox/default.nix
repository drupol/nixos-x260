{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.winbox;
in
{
  options = {
    programs.winbox.enable = lib.mkEnableOption "winbox";
  };

  config = lib.mkIf cfg.enable {
    programs.winbox = {
      enable = true;
    };
    environment.systemPackages = with pkgs; [ winbox ];
    networking = {
      firewall.allowedUDPPorts = [ 5678 ];
    };
  };
}
