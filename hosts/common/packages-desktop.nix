{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    akregator
    ark
    birdtray
    discord
    displaylink
    # android-studio
    element-desktop
    etlegacy
    ioquake3
    jetbrains-toolbox
    # google-chrome
    # graphviz
    # jetbrains.clion
    # jetbrains.datagrip
    # jetbrains.jdk
    # jetbrains.goland
    # jetbrains.pycharm-professional
    # jetbrains.phpstorm
    # jetbrains.idea-ultimate
    # jfsutils
    kate
    kgpg
    krita
    krdc
    ktailctl
    libsForQt5.kdialog
    okular
    openarena
    openxcom
    # plantuml
    plasma-browser-integration
    projecteur
    sddm-kcm
    # signal-desktop
    # slack
    spectacle
    tdesktop
    # teams-for-linux
    vlc
    yakuake
  ];
}
