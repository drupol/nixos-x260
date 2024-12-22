{ pkgs }:

pkgs.nix-webapps-lib.mkChromiumApp {
  appName = "google-meet";
  categories = [
    "Network"
    "Chat"
    "InstantMessaging"
  ];
  class = "chrome-meet.google.com__-Default";
  desktopName = "Google Meet";
  icon = ./Google_Meet_icon.svg;
  url = "https://meet.google.com";
}
