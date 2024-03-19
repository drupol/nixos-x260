{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    birdtray
    chromium
    discord
    # android-studio
    element-desktop
    etlegacy
    gpt4all
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
    kdePackages.ark
    kdePackages.kate
    kdePackages.kgpg
    kdePackages.krdc
    kdePackages.kdialog
    kdePackages.kpipewire
    kdePackages.okular
    kdePackages.plasma-browser-integration
    kdePackages.sddm-kcm
    kdePackages.spectacle
    kdePackages.yakuake
    krita
    ktailctl
    (mkchromecast.override {enableSonos = true;})
    openarena
    openxcom
    signal-desktop
    # slack
    tdesktop
    # teams-for-linux
    vlc
  ];
}
