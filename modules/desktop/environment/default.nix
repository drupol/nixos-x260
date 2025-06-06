{
  inputs,
  ...
}:
{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        xdg = {
          portal = {
            enable = true;
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
        nixpkgs = {
          config.allowUnfree = true;
          overlays = [
            inputs.self.overlays.default
          ];
        };

        home.packages = with pkgs; [
          kdePackages.akonadi-search
          kdePackages.akregator
          kdePackages.ark
          kdePackages.filelight
          kdePackages.kate
          kdePackages.kcalc
          kdePackages.kdialog
          kdePackages.kgpg
          kdePackages.kpipewire
          kdePackages.krdc
          kdePackages.krfb
          kdePackages.ksystemlog
          kdePackages.kweather
          kdePackages.okular
          kdePackages.plasma-browser-integration
          kdePackages.sddm-kcm
          kdePackages.spectacle
          kdePackages.xdg-desktop-portal-kde
          kdePackages.yakuake
          krita
          vlc
          winbox4
          zotero
          pkgs.local.gh-flake-update
        ];
      };
  };
}
