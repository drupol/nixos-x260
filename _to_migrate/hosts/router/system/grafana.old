{ config, ... }:
{
  services.caddy.virtualHosts."grafana.router.lan".extraConfig = ''
    tls internal
    reverse_proxy 127.0.0.1:8888
  '';

  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "grafana.router.lan";
        http_port = 8888;
        http_addr = "0.0.0.0";
        root_url = "%(protocol)s://%(domain)s:%(http_port)s/";
      };

      analytics.reporting_enabled = false;

      smtp = {
        enabled = true;
        host = "smtp.scarlet.be:25";
        from_address = "pol.dellaiera@protonmail.com";
      };
    };

    dataDir = "/var/lib/grafana";
    provision = {
      enable = true;
      # Set up the datasources
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
          isDefault = true;
        }
        {
          name = "Loki";
          type = "loki";
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
          isDefault = false;
        }
      ];
    };
  };
}
