{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    akregator
    ark
    # android-studio
    element-desktop
    gimp
    iosevka
    iosevka-comfy.comfy
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
    krdc
    nerdfonts
    okular
    # plantuml
    plasma-browser-integration
    sddm-kcm
    signal-desktop
    slack
    spectacle
    tdesktop
    teams-for-linux
    vlc
    yakuake
  ];
}
