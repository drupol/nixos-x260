{
  pkgs,
  config,
  ...
}: {
  networking = {
    firewall = {
      allowedTCPPorts = [80];
    };
  };

  services.caddy = {
    enable = true;

    globalConfig = ''
      debug
      auto_https off
    '';

    virtualHosts."raspberrypi400:80".extraConfig = ''
      handle_path /pihole/* {
        reverse_proxy 127.0.0.1:8093
      }
      handle_path /grafana/* {
        reverse_proxy 127.0.0.1:8888
      }
    '';
  };
}
