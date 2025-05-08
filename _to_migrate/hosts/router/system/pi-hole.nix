
{
  services.caddy.virtualHosts."pi-hole.router.lan".extraConfig = ''
    tls internal
    handle_path /* {
      rewrite * /admin{uri}
      reverse_proxy 127.0.0.1:8093
    }
  '';

  networking = {
    firewall = {
      allowedTCPPorts = [
        53
        67
      ];
      allowedUDPPorts = [
        53
        67
        547
      ];
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
        environment = {
          BLOCKING_ENABLED = "true";
          CUSTOM_CACHE_SIZE = "10000";
          DNSMASQ_LISTENING = "all";
          DNSMASQ_USER = "root";
          DHCP_ACTIVE = "true";
          DHCP_IPv6 = "true";
          DHCP_START = "192.168.2.100";
          DHCP_END = "192.168.2.200";
          DHCP_ROUTER = "192.168.2.10";
          DHCP_LEASETIME = "24";
          DHCP_rapid_commit = "true";
          DNS_BOGUS_PRIV = "true";
          DNS_FQDN_REQUIRED = "true";
          DNSSEC = "false";
          FTLCONF_LOCAL_IPV4 = "192.168.2.10";
          FTLCONF_LOCAL_IPV6 = "0:0:0:0:0:ffff:c0a8:020a";
          FTLCONF_MAXDBDAYS = "7";
          FTLCONF_MOZILLA_CANARY = "false";
          FTLCONF_PRIVACYLEVEL = "0";
          FTLCONF_PIHOLE_PTR = "HOSTNAMEFQDN";
          FTLCONF_RATE_LIMIT = "1000/60";
          IPv6 = "true";
          PIHOLE_DOMAIN = "lan";
          PIHOLE_DNS_ = "8.8.8.8;8.8.4.4;2001:4860:4860:0:0:0:0:8888;2001:4860:4860:0:0:0:0:8844;208.67.222.222;208.67.220.220;1.1.1.1;1.0.0.1;2620:119:35::35;2620:119:53::53;2606:4700:4700::1111;2606:4700:4700::1001";
          QUERY_LOGGING = "true";
          REV_SERVER = "false";
          SKIPGRAVITYONBOOT = "1";
          TEMPERATUREUNIT = "c";
          TZ = "Europe/Brussels";
          WEB_BIND_ADDR = "192.168.2.10";
          WEB_PORT = "8093";
          WEBLOGS_STDOUT = "1";
          WEBPASSWORD = "webpassword";
          WEBTHEME = "default-dark";
          WEBUIBOXEDLAYOUT = "traditional";
        };
        volumes = [
          "pihole:/etc/pihole"
          "dnsmasq:/etc/dnsmasq.d"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--network=host"
          "--pull=always"
        ];
      };
    };
  };
}
