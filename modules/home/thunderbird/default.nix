{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.thunderbird;
in
{
  imports = [ ];

  options = {
    thunderbird = {
      enable = lib.mkEnableOption "thunderbird";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      settings = {
        "privacy.donottrackheader.enabled" = true;
      };
      profiles = {
        default = {
          isDefault = true;
        };
      };
    };
  };
}
