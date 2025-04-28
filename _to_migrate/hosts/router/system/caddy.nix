
{
  networking = {
    firewall = {
      allowedTCPPorts = [
        80
        443
      ];
    };
  };

  services.caddy = {
    enable = true;

    # From https://www.reddit.com/r/pihole/comments/xf7059/pihole_behind_caddy_reverse_proxy_redirecting_to/
    virtualHosts."router.lan:80".extraConfig = ''
      handle_path /pihole/* {
        redir / /admin{path}
        reverse_proxy 127.0.0.1:8093
      }
      handle_path /grafana/* {
        reverse_proxy 127.0.0.1:8888
      }
    '';
  };
}
