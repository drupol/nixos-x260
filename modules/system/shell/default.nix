{ config, lib, ... }:
let
  cfg = config.shell;
in
{
  options = {
    shell = {
      enable = lib.mkEnableOption "shell";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish.enable = true;
    programs.command-not-found.enable = false;
    programs.direnv.silent = true;
  };
}
