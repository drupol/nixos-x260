{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
      akregator
      ark
      # android-studio
      element-desktop
      gimp
      google-chrome
      graphviz
      # jetbrains.clion
      # jetbrains.datagrip
      # jetbrains.jdk
      # jetbrains.goland
      # jetbrains.pycharm-professional
      jetbrains.phpstorm
      # jetbrains.idea-ultimate
      # jfsutils
      kate
      kgpg
      krdc
      okular
      plantuml
      sddm-kcm
      signal-desktop
      slack
      spectacle
      tdesktop
      teams
      thunderbird-bin
      vlc
      vscode
      yakuake
    ];
}
