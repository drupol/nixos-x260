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
    messaging.enable = lib.mkEnableOption "messaging";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.local.chromium-discord
      pkgs.local.chromium-element
      pkgs.local.chromium-meet
      pkgs.local.chromium-protonmail
      pkgs.local.chromium-teams
      pkgs.local.chromium-telegram
      pkgs.signal-desktop
    ];
  };
}
