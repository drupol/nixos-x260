{ user, ... }:
{
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "22.05";
  };

  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;
}
