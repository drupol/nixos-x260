{ pkgs }:

pkgs.nix-webapps-lib.mkChromiumApp {
  appName = "teams";
  categories = [
    "Network"
    "Chat"
    "InstantMessaging"
  ];
  class = "chrome-teams.microsoft.com__-Default";
  desktopName = "Microsoft Teams";
  icon = ./Microsoft_Office_Teams.svg;
  url = "https://teams.microsoft.com";
}
