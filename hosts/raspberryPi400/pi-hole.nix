{
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
}
