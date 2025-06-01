{
  flake.modules.homeManager.shell = {
    programs = {
      ghostty = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          font-family = "Aporetic Sans Mono";
          gtk-titlebar = false;
          gtk-adwaita = false;
          background-opacity = "0.95";
          window-theme = "system";
        };
      };
    };
  };
}
