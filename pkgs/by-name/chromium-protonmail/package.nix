{ inputs, pkgs }:

inputs.self.lib.mkChromiumApp pkgs {
  appName = "google-protonmail";
  categories = [
    "Network"
    "Email"
  ];
  class = "chrome-mail.proton.me__-ProtonmailProfile";
  desktopName = "Protonmail";
  icon = ./proton-mail-seeklogo.svg;
  profile = "ProtonmailProfile";
  url = "https://mail.proton.me";
}
