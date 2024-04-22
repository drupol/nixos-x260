{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.thunderbird;
in
{
  imports = [ ];

  options = {
    thunderbird = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Thunderbird";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      birdtray
    ];

    programs.thunderbird = {
      enable = true;
      settings = {
        "general.useragent.override" = "";
        "privacy.donottrackheader.enabled" = true;
        "network.dns.ipv4OnlyDomains" = "outlook.office365.com";
      };
      profiles = {
        default = {
          isDefault = true;
        };
      };
    };
  };
}
