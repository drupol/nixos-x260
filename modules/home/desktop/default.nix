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
    home.packages = with pkgs; [
      aws-workspaces
      kdePackages.ark
      kdePackages.kate
      kdePackages.kdialog
      kdePackages.kgpg
      kdePackages.kpipewire
      kdePackages.krdc
      kdePackages.okular
      kdePackages.sddm-kcm
      kdePackages.spectacle
      kdePackages.yakuake
      krita
      ktailctl
      mailspring
      vlc
      vscode-runner
      zotero

      kdePackages.kaccounts-integration
      kdePackages.kaccounts-providers
      kdePackages.plasma-browser-integration # browser integration (chrome/firefox)
      kdePackages.kmail # mail application
      kdePackages.kmail-account-wizard
      kdePackages.kmailtransport
      kdePackages.kmail
      kdePackages.accounts-qt
      kdePackages.kontact # contacts application
      kdePackages.kate # kwrite
      kdePackages.kcalc # calculator
      kdePackages.filelight # disk usage analyzer
      kdePackages.korganizer # calendar/organizer
      kdePackages.akregator # rss feed reader
      kdePackages.kaddressbook # contact addressbook
      kdePackages.kweather # weather app
      kdePackages.kasts # podcast app
      kdePackages.plasmatube # youtube app
      kdePackages.krfb # Krfb Desktop Sharing (VNC)
      kdePackages.kauth
      kdePackages.ksystemlog # syslog viewer
    ];
  };
}
