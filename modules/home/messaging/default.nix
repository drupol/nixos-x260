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
    home.packages = with pkgs; [
      chromium-discord
      chromium-element
      chromium-meet
      chromium-protonmail
      chromium-teams
      chromium-telegram
      signal-desktop
    ];
  };
}
