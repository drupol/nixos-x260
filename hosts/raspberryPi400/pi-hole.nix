{
  pkgs,
  lib,
  ...
}: {
  networking = {
    firewall = {
      allowedTCPPorts = [53 67 80 8888];
      allowedUDPPorts = [53 67];
    };
  };

  systemd.services = {
    prometheus-pihole-exporter = {
      serviceConfig.ExecStart = lib.mkForce ''
        ${pkgs.bash}/bin/bash -c "${pkgs.prometheus-pihole-exporter}/bin/pihole-exporter \
          -pihole_api_token 4d35bbf234f12338c0617746043c52c1f92e37c9457d8f3d1441feb2036d91b8 \
          -pihole_hostname 127.0.0.1 \
          -pihole_port 80 \
          -pihole_protocol http \
          -port 9006"
      '';
    };
  };

  virtualisation = {
    containers = {
      enable = true;
      containersConf = {
        settings = {
          engine.helper_binaries_dir = ["${pkgs.netavark}/bin"];
        };
      };
    };

    podman = {
      enable = true;
      dockerCompat = true;
    };

    oci-containers.backend = "podman";
    oci-containers.containers = {
      pi-hole = {
        autoStart = true;
        image = "pihole/pihole:latest";

        ports = [
          "53:53/tcp"
          "53:53/udp"
          "67:67/udp"
          "80:80/tcp"
        ];
        environment = {
          TZ = "Europe/Brussels";
          WEBPASSWORD = "webpassword";
          ServerIP = "192.168.2.10";
          VIRTUAL_HOST = "pihole.dns";
          DNSMASQ_LISTENING = "all";
          PIHOLE_DOMAIN = "local";
          DNSMASQ_USER = "root";
          CUSTOM_CACHE_SIZE = "10000";
          IPv6 = "true";
          DHCP_ACTIVE = "true";
          DHCP_IPv6 = "true";
          DHCP_START = "192.168.2.100";
          DHCP_END = "192.168.2.200";
          DHCP_ROUTER = "192.168.2.10";
          DHCP_LEASETIME = "24";
          DHCP_rapid_commit = "true";
          DNS_BOGUS_PRIV = "true";
          DNS_FQDN_REQUIRED = "true";
          TEMPERATUREUNIT = "c";
          WEBUIBOXEDLAYOUT = "traditional";
          QUERY_LOGGING = "false";
          FTLCONF_REPLY_ADDR4 = "192.168.2.10";
          WEBTHEME = "default-dark";
          PIHOLE_DNS_1 = "8.8.8.8";
          PIHOLE_DNS_2 = "8.8.4.4";
          PIHOLE_DNS_3 = "2001:4860:4860:0:0:0:0:8888";
          PIHOLE_DNS_4 = "2001:4860:4860:0:0:0:0:8844";
          PIHOLE_DNS_5 = " 208.67.222.222";
          PIHOLE_DNS_6 = "208.67.220.220";
          PIHOLE_DNS_7 = "2620:119:35::35";
          PIHOLE_DNS_8 = "2620:119:53::53";
          PIHOLE_DNS_9 = "1.1.1.1";
          PIHOLE_DNS_10 = "1.0.0.1";
          PIHOLE_DNS_11 = "2606:4700:4700::1111";
          PIHOLE_DNS_12 = "2606:4700:4700::1001";
          BLOCKING_ENABLED = "true";
          IPV4_ADDRESS = "0.0.0.0";
          IPV6_ADDRESS = "0:0:0:0:0:0";
        };
        volumes = [
          "pihole:/etc/pihole"
          "dnsmasq:/etc/dnsmasq.d"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--network=host"
          "--pull=newer"
          "--dns=127.0.0.1"
        ];
      };
    };
  };

  services.prometheus.exporters.pihole = {
    enable = true;
    port = 9006;
    apiToken = "4d35bbf234f12338c0617746043c52c1f92e37c9457d8f3d1441feb2036d91b8";
    piholeHostname = "127.0.0.1";
    piholePort = 80;
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "pihole";
      static_configs = [{targets = ["127.0.0.1:9006"];}];
      scrape_interval = "15s";
    }
  ];
}
