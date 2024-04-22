{ config, lib, ... }:
let
  cfg = config.desktop;
in
{
  imports = [ (lib.mkIf cfg.enable (import ./kdeplasma.nix { })) ];

  options = {
    desktop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable KDE Plasma Desktop";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    firefox.enable = true;
    thunderbird.enable = true;
  };
}
