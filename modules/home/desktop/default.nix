{ config, lib, pkgs, hostConfig, ... }:
let
  cfg = config.desktop;
in
{
  imports = [ (lib.mkIf cfg.enable (import ./kdeplasma.nix { })) ];

  options = {
    desktop = {
      enable = lib.mkEnableOption "desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    firefox.enable = true;
    thunderbird.enable = true;

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
  };
}
