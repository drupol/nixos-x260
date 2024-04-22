{ config
, lib
, pkgs
, hostConfig
, ...
}:
let
  cfg = config.desktop;
in
{
  options = {
    desktop.enable = lib.mkEnableOption "desktop";
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      portal = {
        config.common.default = "kde";
        extraPortals = with pkgs; [
          libsForQt5.xdg-desktop-portal-kde
        ];
      };
    };

    home-manager.users.${hostConfig.user}.imports = [
      ({
        home.packages = with pkgs; [
          chromium
          discord
          element-desktop
          gpt4all
          kdePackages.ark
          kdePackages.kate
          kdePackages.kgpg
          kdePackages.krdc
          kdePackages.kdialog
          kdePackages.kpipewire
          kdePackages.okular
          kdePackages.plasma-browser-integration
          kdePackages.sddm-kcm
          kdePackages.spectacle
          kdePackages.yakuake
          krita
          ktailctl
          (mkchromecast.override { enableSonos = true; })
          signal-desktop
          tdesktop
          vlc
        ];
      })
    ];

    services = {
      xserver.enable = true;
      desktopManager = {
        plasma6 = {
          enable = true;
        };
      };
      displayManager = {
        sddm = {
          enable = true;
        };
      };
    };
  };
}
