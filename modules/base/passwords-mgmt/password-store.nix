{
  flake.modules = {
    homeManager.base =
      { config, ... }:
      {
        programs = {
          password-store = {
            enable = true;
            settings = {
              PASSWORD_STORE_DIR = "${config.xdg.configHome}/.password-store";
            };
          };
        };
      };
  };
}
