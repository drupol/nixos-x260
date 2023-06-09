{ pkgs
, config
, ...
}: {
  environment.systemPackages = [ pkgs.tailscale ];

  services.headscale = {
    enable = true;
    settings = {
      dns_config = {
        magic_dns = true;
        nameservers = [ "192.168.2.10" ];
        base_domain = "pihole.local";
      };
      db_path = "/var/lib/headscale/db.sqlite";
      server_url = "http://192.168.2.10:8080";
    };
    address = "0.0.0.0";
    port = 8080;
  };

  networking.firewall = {
    allowedTCPPorts = [ config.services.headscale.port ];
    allowedUDPPorts = [ config.services.headscale.port ];
  };
}
