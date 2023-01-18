{
  enable = true;
  settings = {
    server.http_port = 8888;
    server.http_addr = "0.0.0.0";
  };

  dataDir = "/var/lib/grafana";
  provision = {
    enable = true;
    # Set up the datasources
    datasources.settings.datasources = [
      {
        name = "Prometheus";
        type = "prometheus";
        access = "proxy";
        url = "http://localhost:9001";
        isDefault = true;
      }
      {
        name = "Loki";
        type = "loki";
        access = "proxy";
        url = "http://localhost:3100";
        isDefault = false;
      }
    ];
  };
}
