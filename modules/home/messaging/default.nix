{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.messaging;
in
{
  options = {
    messaging = {
      enable = lib.mkEnableOption "messaging";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      element-desktop
      signal-desktop
      tdesktop
    ];
  };
}
