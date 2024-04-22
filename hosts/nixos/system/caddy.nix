{ pkgs, ... }: {
  services = {
    caddy = {
      enable = true;
      email = "example@example.com";
    };
  };
}
