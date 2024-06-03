{
  inputs,
  pkgs,
}:

inputs.self.lib.mkChromiumApp pkgs {
  appName = "teams";
  desktopName = "Microsoft Teams";
  icon = ./Microsoft_Office_Teams.svg;
  url = "https://teams.microsoft.com";
  class = "chrome-teams.microsoft.com__-Default";
  categories = [ "Network" "Chat" "InstantMessaging" ];
  profile = "TeamsProfile";
}
