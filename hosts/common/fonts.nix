{ config
, pkgs
, ...
}: {
  fonts.packages = with pkgs; [
    dina-font
    iosevka
    iosevka-comfy.comfy
    monaspace
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [
        "Iosevka Comfy"
        "Iosevka Comfy"
      ];
      sansSerif = [ "Iosevka Comfy" ];
      serif = [ "Iosevka Comfy" ];
    };
  };

}
