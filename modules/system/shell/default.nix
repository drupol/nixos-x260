{ config
, lib
, ...
}:
let
  cfg = config.shell;
in
{
  options = {
    shell = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable shell";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish.enable = true;
    programs.command-not-found.enable = false;
  };
}
