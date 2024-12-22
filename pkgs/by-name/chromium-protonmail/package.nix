{ pkgs }:

pkgs.nix-webapps-lib.mkChromiumApp {
  appName = "google-protonmail";
  categories = [
    "Network"
    "Email"
  ];
  class = "chrome-mail.proton.me__-Default";
  desktopName = "Protonmail";
  icon = ./proton-mail-seeklogo.svg;
  url = "https://mail.proton.me";
}
