{
  inputs,
  pkgs,
}:

inputs.self.lib.mkChromiumApp pkgs {
  appName = "google-meet";
  desktopName = "Google Meet";
  url = "https://meet.google.com";
  icon = ./Google_Meet_icon.svg;
  class = "chrome-meet.google.com__-Default";
  categories = [ "Network" "Chat" "InstantMessaging" ];
  profile = "GoogleMeetProfile";
}
