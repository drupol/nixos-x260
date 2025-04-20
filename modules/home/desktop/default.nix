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
    ];
  };
}
