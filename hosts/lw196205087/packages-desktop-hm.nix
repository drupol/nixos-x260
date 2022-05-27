{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
      # android-studio
      element-desktop
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
      plantuml
      signal-desktop
      slack
      tdesktop
      teams
      vscode
    ];
}
