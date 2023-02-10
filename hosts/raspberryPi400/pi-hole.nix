{
  pkgs,
  lib,
  ...
}: {
  networking = {
    firewall = {
      allowedTCPPorts = [53 67 80];
      allowedUDPPorts = [53 67 547];
    };
  };

  virtualisation = {
    containers = {
      enable = true;
    };

    oci-containers.backend = "docker";
    oci-containers.containers = {
      pi-hole = {
        autoStart = true;
        image = "pihole/pihole:latest";

        ports = [
          "53:53/tcp"
          "53:53/udp"
          "67:67/udp"
          "8093:8093/tcp"
          "547:547/udp"
        ];
        environment = {
          TZ = "Europe/Brussels";
          WEBPASSWORD = "webpassword";
          WEB_PORT = "8093";
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
          FTLCONF_LOCAL_ADDR4 = "0.0.0.0";
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
          DNSSEC = "false";
          REV_SERVER = "false";
          RATE_LIMIT = "1000/60";
          PRIVACYLEVEL = "0";
        };
        volumes = [
          "pihole:/etc/pihole"
          "dnsmasq:/etc/dnsmasq.d"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--network=host"
          "--pull=newer"
        ];
      };
    };
  };
}
