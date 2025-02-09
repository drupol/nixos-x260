{
  config,
  lib,
  pkgs,
  chromium-discord,
  chromium-element,
  chromium-meet,
  chromium-protonmail,
  chromium-teams,
  chromium-telegram,
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
      chromium-discord
      chromium-element
      chromium-meet
      chromium-protonmail
      chromium-teams
      chromium-telegram
      pkgs.signal-desktop
    ];
  };
}
