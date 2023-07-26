{ config
, pkgs
, ...
}: {
  fonts.packages = with pkgs; [
    dina-font
    iosevka
    iosevka-comfy.comfy
    nerdfonts
  ];
}
