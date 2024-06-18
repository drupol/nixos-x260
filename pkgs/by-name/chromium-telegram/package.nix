{ inputs, pkgs }:

inputs.self.lib.mkChromiumApp pkgs {
  appName = "telegram";
  categories = [
    "Network"
    "Chat"
    "InstantMessaging"
  ];
  class = "chrome-web.telegram.org__-TelegramProfile";
  desktopName = "Telegram";
  profile = "TelegramProfile";
  url = "https://web.telegram.org";
}
