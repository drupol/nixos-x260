{
  pkgs,
  lib,
  ...
}: {
  services.prometheus = {
    enable = true;
    port = 9990;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd" "netdev"];
        port = 9991;
      };
      shelly = {
        enable = true;
        metrics-file = "/shelly-metrics.json";
      };
    };
    scrapeConfigs = [
      # Scrape the current system
      {
        job_name = "node";
        static_configs = [{targets = ["127.0.0.1:9991"];}];
        scrape_interval = "15s";
      }
      # Scrape the current system
      {
        job_name = "shelly";
        static_configs = [{targets = ["127.0.0.1:9784"];}];
        scrape_interval = "15s";
      }
    ];
  };
}
