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
      firefox
      fish
      gimp
      git
      gitui
      gnupg
      google-chrome
      # gradle                              # Java dependency manager
      graphviz
      htop
      # jetbrains.datagrip
      # jetbrains.jdk
      # jetbrains.goland
      # jetbrains.pycharm-professional
      # jetbrains.phpstorm
      jetbrains.idea-ultimate
      jfsutils
      kate
      kgpg
      krdc
      # openjdk                             # Java Development Kit for Java 
      krunner-pass
      # maven                               # Java dependency manager
      neofetch
      okular
      p7zip
      pass
      plantuml
      plasma-browser-integration
      sddm-kcm
      signal-desktop
      slack
      spectacle
      tdesktop
      teams
      thunderbird-bin
      vlc
      vscode
      wget
      wineWowPackages.stable
      yakuake
    ];
}
