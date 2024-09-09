{ inputs, pkgs }:

inputs.self.lib.mkChromiumApp pkgs {
  appName = "google-protonmail";
  categories = [
    "Network"
    "Mail"
  ];
  class = "chrome-mail.proton.me__-ProtonmailProfile";
  desktopName = "Google Meet";
  icon = ./proton-mail-seeklogo.svg;
  profile = "ProtonmailProfile";
  url = "https://mail.proton.me";
}
