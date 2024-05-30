{
  config,
  lib,
  pkgs,
  ...
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
        extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
      };
    };

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
