{ pkgs }:

pkgs.nix-webapps-lib.mkChromiumApp {
  appName = "telegram";
  categories = [
    "Network"
    "Chat"
    "InstantMessaging"
  ];
  class = "chrome-web.telegram.org__-Default";
  desktopName = "Telegram";
  url = "https://web.telegram.org";
}
