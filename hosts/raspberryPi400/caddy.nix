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
        rewrite * /admin{uri}
        reverse_proxy 127.0.0.1:8093
      }
      handle_path /grafana/* {
        reverse_proxy 127.0.0.1:8888
      }
      handle_path /wetty/* {
        reverse_proxy 127.0.0.1:3000
      }
    '';

    virtualHosts."wpad.lan:80".extraConfig = ''
      handle * {
        root * ${./resources/caddy}
        file_server
      }
    '';
  };
}
