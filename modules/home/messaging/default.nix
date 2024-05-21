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
    home.packages =
      let
        # Proudly stolen from https://codeberg.org/xlambein/nixos
        makeChromiumApp =
          {
            name,
            desktopName,
            url,
            mimeTypes ? [ ],
          }:
          pkgs.makeDesktopItem {
            inherit name desktopName mimeTypes;
            exec = "${pkgs.chromium}/bin/chromium --enable-features=UseOzonePlatform --ozone-platform=wayland --app=${url}";
            terminal = false;
          };
      in
      with pkgs;
      [
        discord
        element-desktop
        signal-desktop
        tdesktop
        (makeChromiumApp {
          name = "teams";
          desktopName = "Teams";
          url = "https://teams.microsoft.com/";
          mimeTypes = [ "x-scheme-handler/msteams" ];
        })
      ];
  };
}
