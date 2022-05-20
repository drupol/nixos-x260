{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
      akregator
      # android-studio
      element-desktop
      gimp
      google-chrome
      graphviz
      htop
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
