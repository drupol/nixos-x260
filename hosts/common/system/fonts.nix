{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    dina-font
    aporetic
    monaspace
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [
        "Aporetic Sans Mono"
      ];
      sansSerif = [ "Aporetic Sans Mono" ];
      serif = [ "Aporetic Sans Mono" ];
    };
  };
}
