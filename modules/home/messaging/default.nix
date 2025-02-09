{
  self,
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
    # TODO: Find a way to use the `pkgs` variable here.
    # See https://github.com/drupol/pkgs-by-name-for-flake-parts/pull/2
    home.packages = with self.packages.x86_64-linux; [
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
