{
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
    DNSMASQ_LISTENING = "all";
  };
  volumes = [
    "pihole:/etc/pihole"
    "dnsmasq:/etc/dnsmasq.d"
  ];
}
