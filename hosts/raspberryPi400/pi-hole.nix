{
  image = "pihole/pihole:latest";
  ports = [
    "53:53"
    "67:67"
    "80:80"
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
