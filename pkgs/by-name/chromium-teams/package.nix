{
  inputs,
  pkgs,
}:

inputs.self.lib.mkChromiumApp pkgs {
  appName = "teams";
  categories = [ "Network" "Chat" "InstantMessaging" ];
  class = "chrome-teams.microsoft.com__-TeamsProfile";
  desktopName = "Microsoft Teams";
  icon = ./Microsoft_Office_Teams.svg;
  profile = "TeamsProfile";
  url = "https://teams.microsoft.com";
}
