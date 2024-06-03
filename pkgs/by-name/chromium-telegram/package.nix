{
  inputs,
  pkgs,
}:

inputs.self.lib.mkChromiumApp pkgs {
  appName = "telegram";
  desktopName = "Telegram";
  url = "https://web.telegram.org";
  class = "chrome-web.telegram.org__-Default";
  categories = [ "Network" "Chat" "InstantMessaging" ];
  profile = "TelegramProfile";
}
