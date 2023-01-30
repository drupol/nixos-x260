{
  pkgs,
  lib,
  ...
}: let
  prometheus-shelly-exporter = pkgs.callPackage ./shelly-exporter.nix {};
in {
  systemd.services = {
    prometheus-shelly-exporter = {
      serviceConfig.ExecStart = lib.mkForce ''
        ${pkgs.bash}/bin/bash -c "${prometheus-shelly-exporter}/bin/shelly_exporter \
          -metrics-file /home/pol/nix/shelly-metrics.json"
      '';
    };
  };

  services.prometheus = {
    enable = true;
    port = 9990;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd" "netdev"];
        port = 9991;
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
