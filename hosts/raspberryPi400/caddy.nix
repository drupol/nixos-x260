{
  pkgs,
  config,
  ...
}: {
  networking = {
    firewall = {
      allowedTCPPorts = [80 443];
    };
  };

  services.caddy = {
    enable = true;

    virtualHosts."raspberrypi400:80".extraConfig = ''
      handle_path /pihole/* {
        rewrite * /admin{path}
        reverse_proxy 127.0.0.1:8093
      }
      handle_path /grafana/* {
        reverse_proxy 127.0.0.1:8888
      }
    '';
  };
}
