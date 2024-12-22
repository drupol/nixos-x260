{ pkgs }:

pkgs.nix-webapps-lib.mkChromiumApp {
  appName = "discord";
  categories = [
    "Network"
    "Chat"
    "InstantMessaging"
  ];
  class = "chrome-discord.com__app-Default";
  desktopName = "Discord";
  icon = ./discord-icon.svg;
  url = "https://discord.com/app";
}
