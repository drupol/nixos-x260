{ pkgs }:

pkgs.nix-webapps-lib.mkChromiumApp {
  appName = "element";
  categories = [
    "Network"
    "Chat"
    "InstantMessaging"
  ];
  class = "chrome-app.element.io__-Default";
  desktopName = "Element";
  icon = ./Element_logo.svg;
  url = "https://app.element.io";
}
