{
  flake.modules.homeManager.dev =
    { config, ... }:
    {
      xdg = {
        userDirs = {
          extraConfig = {
            XDG_CODE_DIR = "${config.home.homeDirectory}/Code";
          };
        };
      };
    };
}
