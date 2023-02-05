{
  pkgs,
  config,
  ...
}: {
  networking = {
    firewall = {
      allowedTCPPorts = [8888];
    };
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "raspberryPi400";
        http_port = 8888;
        http_addr = "0.0.0.0";
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
