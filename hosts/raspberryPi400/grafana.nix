{pkgs, ...}: {
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
          url = "http://localhost:9990";
          isDefault = true;
        }
        {
          name = "Loki";
          type = "loki";
          url = "http://localhost:3100";
          isDefault = false;
        }
      ];
    };
  };
}
