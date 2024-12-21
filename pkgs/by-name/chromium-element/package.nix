{ pkgs }:

pkgs.nix-webapps-lib.mkChromiumApp {
  appName = "element";
  categories = [
    "Network"
    "Chat"
    "InstantMessaging"
  ];
  class = "chrome-app.element.io__-ElementProfile";
  desktopName = "Element";
  icon = ./Element_logo.svg;
  profile = "ElementProfile";
  url = "https://app.element.io";
}
