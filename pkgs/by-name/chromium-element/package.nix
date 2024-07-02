{ inputs, pkgs }:

inputs.self.lib.mkChromiumApp pkgs {
  appName = "element";
  categories = [
    "Network"
    "Chat"
    "InstantMessaging"
  ];
  class = "chrome-app.element.io__-ElementProfile";
  desktopName = "Element";
  profile = "ElementProfile";
  url = "https://app.element.io";
}
