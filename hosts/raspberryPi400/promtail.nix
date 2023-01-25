{pkgs, ...}: {
  systemd.tmpfiles.rules = [
    "d /var/lib/loki 0700 loki loki - -"
    "d /var/lib/loki/ruler 0700 loki loki - -"
  ];

  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false;
      server = {
        http_listen_port = 3100;
      };
      analytics.reporting_enabled = false;
      common = {
        path_prefix = "/var/lib/loki";
        storage.filesystem = {
          chunks_directory = "/var/lib/loki/chunks";
          rules_directory = "/var/lib/loki/rules";
        };
        replication_factor = 1;
        ring = {
          instance_addr = "127.0.0.1";
          kvstore.store = "inmemory";
        };
      };

      schema_config = {
        configs = [
          {
            from = "2022-05-15";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };

      ruler.alertmanager_url = "http://127.0.0.1:9001";
    };
  };

  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
      '';
    };
  };

  services.prometheus.scrapeConfigs = [
    # Scrape the Loki service
    {
      job_name = "Loki service";
      static_configs = [{targets = ["127.0.0.1:3100"];}];
      scrape_interval = "15s";
    }
  ];
}
