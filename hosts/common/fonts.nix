{ config
, pkgs
, ...
}: {
  fonts.fonts = with pkgs; [
    dina-font
    iosevka
    iosevka-comfy.comfy
    nerdfonts
  ];
}
