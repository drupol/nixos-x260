{
  inputs,
  pkgs,
}:

inputs.self.lib.mkChromiumApp pkgs {
  appName = "discord";
  desktopName = "Discord";
  icon = ./discord-icon.svg;
  url = "https://discord.com/app";
  class = "chrome-discord.com__app-Default";
}
