{
  enable = true;
  port = 9990;
  exporters = {
    node = {
      enable = true;
      enabledCollectors = ["systemd"];
      port = 9991;
    };
  };
  scrapeConfigs = [
    {
      job_name = "chrysalis";
      static_configs = [{targets = ["127.0.0.1:9991"];}];
    }
  ];
}
