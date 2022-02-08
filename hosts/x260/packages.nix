# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
      akregator
      android-studio
      any-nix-shell
      ark
      bat
      browserpass
      docker
      element-desktop
      exa
      fd
      firefox-bin
      fish
      gimp
      git
      gnupg
      google-chrome
      graphviz
      htop
      jetbrains.datagrip
      # jetbrains.jdk
      jetbrains.goland
      jetbrains.pycharm-professional
      jetbrains.phpstorm
      jetbrains.idea-ultimate
      # jfsutils
      kate
      kgpg
      krdc
      openjdk                             # Java Development Kit for Java
      # krunner-pass
      neofetch
      okular
      p7zip
      pass
      plantuml
      sddm-kcm
      signal-desktop
      slack
      spectacle
      tdesktop
      teams
      tig
      thunderbird-bin
      vlc
      vscode
      wget
      wineWowPackages.stable
      yakuake
    ];
}
