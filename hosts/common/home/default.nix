{ pkgs
, config
, ...
}: {
  home.stateVersion = "23.05";

  fonts = { fontconfig = { enable = true; }; };

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
    ".config/birdtray-config.json" = {
      source = ./. + "/../../../files/home/pol/.config/birdtray-config.json";
      recursive = true;
    };
  };

  programs = {
    home-manager = { enable = true; };
    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };
    micro = {
      enable = true;
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
