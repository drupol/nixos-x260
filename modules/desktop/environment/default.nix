{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        xdg = {
          portal = {
            config.common.default = "kde";
            extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
          };
        };

        services = {
          xserver = {
            enable = true;
            xkb = {
              options = "eurosign:e";
            };
          };
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

        # Only for Winbox
        networking = {
          firewall.allowedUDPPorts = [ 5678 ];
        };
      };

    homeManager.desktop =
      { pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;

        home.packages = with pkgs; [
          aws-workspaces
          kdePackages.accounts-qt
          kdePackages.akregator
          kdePackages.ark
          kdePackages.filelight
          kdePackages.kaccounts-integration
          kdePackages.kaccounts-providers
          kdePackages.kaddressbook
          kdePackages.kate
          kdePackages.kate
          kdePackages.kauth
          kdePackages.kcalc
          kdePackages.kdialog
          kdePackages.kgpg
          kdePackages.kmail
          kdePackages.kmail
          kdePackages.kmail-account-wizard
          kdePackages.kmailtransport
          kdePackages.kontact
          kdePackages.korganizer
          kdePackages.kpipewire
          kdePackages.krdc
          kdePackages.krfb
          kdePackages.ksystemlog
          kdePackages.kweather
          kdePackages.okular
          kdePackages.plasma-browser-integration
          kdePackages.plasmatube
          kdePackages.sddm-kcm
          kdePackages.spectacle
          kdePackages.yakuake
          krita
          ktailctl
          mailspring
          vlc
          vscode-runner
          winbox4
          zotero
        ];
      };
  };
}
