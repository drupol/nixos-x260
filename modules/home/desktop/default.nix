{ config, lib, ... }:
let
  cfg = config.desktop;
in
{
  imports = [ (lib.mkIf cfg.enable (import ./kdeplasma.nix { })) ];

  options = {
    desktop = {
      enable = lib.mkEnableOption "desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    firefox.enable = true;
    thunderbird.enable = true;
  };
}
