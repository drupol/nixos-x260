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
  extraOptions = ["--cap-add=NET_ADMIN" "--dns=127.0.0.1"];
}
