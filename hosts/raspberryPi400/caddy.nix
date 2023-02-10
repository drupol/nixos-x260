{
  pkgs,
  config,
  ...
}: {
  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https off
    '';
    virtualHosts."raspberrypi400".extraConfig = ''
      handle /pihole/ {
        reverse_proxy localhost:8093
      }
      handle /grafana/ {
        reverse_proxy localhost:8888
      }
    '';
  };
}
