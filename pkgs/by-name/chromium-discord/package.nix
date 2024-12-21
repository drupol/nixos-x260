{ pkgs }:

pkgs.nix-webapps-lib.mkChromiumApp {
  appName = "discord";
  categories = [
    "Network"
    "Chat"
    "InstantMessaging"
  ];
  class = "chrome-discord.com__app-DiscordProfile";
  desktopName = "Discord";
  icon = ./discord-icon.svg;
  profile = "DiscordProfile";
  url = "https://discord.com/app";
}
