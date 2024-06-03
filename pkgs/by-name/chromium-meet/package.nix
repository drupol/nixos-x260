{
  inputs,
  pkgs,
}:

inputs.self.lib.mkChromiumApp pkgs {
  appName = "google-meet";
  categories = [ "Network" "Chat" "InstantMessaging" ];
  class = "chrome-meet.google.com__-GoogleMeetProfile";
  desktopName = "Google Meet";
  icon = ./Google_Meet_icon.svg;
  profile = "GoogleMeetProfile";
  url = "https://meet.google.com";
}
