{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    ark
    birdtray
    chromium
    discord
    displaylink
    # android-studio
    element-desktop
    etlegacy
    gpt4all-chat
    ioquake3
    # jetbrains-toolbox
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
    (mkchromecast.override {enableSonos = true;})
    okular
    openarena
    openxcom
    # plantuml
    plasma-browser-integration
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
