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
  imports = [ (lib.mkIf cfg.enable (import ./kdeplasma.nix { })) ];

  options = {
    desktop = {
      enable = lib.mkEnableOption "desktop" // {
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    firefox.enable = true;
    thunderbird.enable = true;

    home.packages = with pkgs; [
      kdePackages.ark
      kdePackages.kate
      kdePackages.kgpg
      kdePackages.krdc
      kdePackages.kdialog
      kdePackages.kpipewire
      kdePackages.okular
      kdePackages.sddm-kcm
      kdePackages.spectacle
      kdePackages.yakuake
      krita
      ktailctl
      (mkchromecast.override { enableSonos = true; })
      vlc
    ];
  };
}
