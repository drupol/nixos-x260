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
    '';

    virtualHosts."192.168.2.10:80".extraConfig = ''
      handle * {
        respond ${./wpad.dat}
      }
    '';
  };
}
