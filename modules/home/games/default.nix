{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.games;
in
{
  options = {
    games.enable = lib.mkEnableOption "Games";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      etlegacy
      ioquake3
      openarena
      openxcom
    ];
  };
}
