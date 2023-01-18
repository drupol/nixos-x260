{
  enable = true;
  port = 9990;
  exporters = {
    node = {
      enable = true;
      enabledCollectors = ["systemd" "netdev"];
      port = 9991;
    };
    pihole = {
      enable = true;
      port = 9006;
      apiToken = "4d35bbf234f12338c0617746043c52c1f92e37c9457d8f3d1441feb2036d91b8";
      piholeHostname = "127.0.0.1";
      piholePort = 80;
    };
  };
  scrapeConfigs = [
    {
      job_name = "pihole";
      static_configs = [{targets = ["127.0.0.1:9006"];}];
      scrape_interval = "15s";
    }
    # Scrape the current system
    {
      job_name = "node";
      static_configs = [{targets = ["127.0.0.1:9991"];}];
      scrape_interval = "15s";
    }
    # Scrape the Loki service
    {
      job_name = "Loki service";
      static_configs = [{targets = ["127.0.0.1:3100"];}];
      scrape_interval = "15s";
    }
  ];
}
