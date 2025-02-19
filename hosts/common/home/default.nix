{ config, ... }:
{
  # See https://ohai.social/@rycee/112502545466617762
  # See https://github.com/nix-community/home-manager/issues/5452
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";

  fonts = {
    fontconfig = {
      enable = true;
    };
  };

  home.file = {
    ".face" = {
      source = ./. + "/../../../files/home/pol/.face";
      recursive = true;
    };
    ".face.icon" = {
      source = ./. + "/../../../files/home/pol/.face";
      recursive = true;
    };
    "${config.xdg.configHome}/.password-store/.keep" = {
      text = "";
      recursive = true;
    };
    "Code/" = {
      source = ./. + "/../../../files/home/pol/Code/";
      recursive = true;
    };
    # Credits to https://store.kde.org/p/1272202
    "Pictures/Backgrounds/" = {
      source = ./. + "/../../../files/home/pol/Pictures/Backgrounds/";
      recursive = true;
    };
  };

  programs = {
    micro = {
      enable = true;
      settings = {
      	diffgutter = true;
        keymenu = true;
        mkparents = true;
        tabsize = 2;
        tabstospaces = true;
      };
    };
    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${config.xdg.configHome}/.password-store";
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      sshKeys = [ "143BC4FB7B3AC7C4F902ADCB579D2F66CDA1844A" ];
    };
  };
}
