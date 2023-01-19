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
    FTLCONF_REPLY_ADDR4 = "192.168.2.10";
    ServerIP = "192.168.2.10";
    VIRTUAL_HOST = "pihole.dns";
    DNSMASQ_LISTENING = "all";
    PIHOLE_DOMAIN = "local";
    PIHOLE_DNS_ = "1.1.1.3;1.0.0.3;208.67.222.222;208.67.220.220";
    DNSMASQ_USER = "root";
    CUSTOM_CACHE_SIZE = "10000";
    DHCP_ACTIVE = "true";
    DHCP_IPv6 = "true";
    IPv6 = "true";
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
    WEBTHEME = "default-dark";
    REV_SERVER = "true";
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
