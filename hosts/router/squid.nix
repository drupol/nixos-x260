{ pkgs, ... }:
let
  # Generating self-signed cert:
  # cd /var/secrets
  # openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout squidCA.key -out squidCA.pem
  # cat squidCA.pem squidCA.key > squidCA.full.pem
  # chown squid squid*
  # chmod 400 squid*
  # Update nix-configs/common/proxycert.pem
  certFullKeyPath = "/var/secrets/squidCA.full.pem";
  certKeyPath = "/var/secrets/squidCA.key";

  configText = ''
    shutdown_lifetime 0 seconds
    acl intermediate_fetching transaction_initiator certificate-fetching
    http_access allow intermediate_fetching

    acl localnet src 100.64.0.0/10  # RFC 6598 shared address space (CGN)
    acl localnet src 192.168.0.0/16 # RFC 1918 possible internal network
    acl localnet src 192.168.0.0/16 # RFC 1918 possible internal network
    acl localnet src fc00::/7       # RFC 4193 local private network range
    acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines

    acl SSL_ports port 443          # https
    acl Safe_ports port 80          # http
    acl Safe_ports port 21          # ftp
    acl Safe_ports port 443         # https
    acl Safe_ports port 70          # gopher
    acl Safe_ports port 210         # wais
    acl Safe_ports port 280         # http-mgmt
    acl Safe_ports port 488         # gss-http
    acl Safe_ports port 591         # filemaker
    acl Safe_ports port 777         # multiling http
    acl CONNECT method CONNECT

    # Deny requests to certain unsafe ports
    http_access deny !Safe_ports

    # Deny CONNECT to other than secure SSL ports
    http_access deny CONNECT !SSL_ports

    # Only allow cachemgr access from localhost
    http_access allow localhost manager
    http_access deny manager

    # We strongly recommend the following be uncommented to protect innocent
    # web applications running on the proxy server who think the only
    # one who can access services on "localhost" is a local user
    http_access deny to_localhost

    # Application logs to syslog, access and store logs have specific files
    cache_log       stdio:/dev/stdout
    access_log      stdio:/var/log/squid/access.log
    cache_store_log stdio:/var/log/squid/store.log
    coredump_dir /var/cache/squid

    # Required by systemd service
    pid_filename    /run/squid.pid

    # Run as user and group squid
    cache_effective_user squid squid

    # Example rule allowing access from your local networks.
    # Adapt localnet in the ACL section to list your (internal) IP networks
    # from where browsing should be allowed
    http_access allow localnet
    http_access allow localhost

    # And finally deny all other access to this proxy
    http_access deny all

    #en fin de fichier ajouter
    sslcrtd_program ${pkgs.squid}/libexec/security_file_certgen -s /var/cache/squid/ssl_db -M 4MB
    sslcrtd_children 4 startup=1 idle=1
    sslproxy_cert_error allow all
    ssl_bump stare all
    #replacer la directive http_port, je précise que il n'y a pas de retour chariot sur le cipher= tout doit être sur une même ligne
    http_port 3128 tcpkeepalive=60,30,3 ssl-bump generate-host-certificates=on \
      dynamic_cert_mem_cache_size=20MB \
      cert=${certFullKeyPath} \
      key=${certKeyPath}
  '';
in
{
  services.squid = {
    enable = true;
    inherit configText;
  };

  networking.firewall.allowedTCPPorts = [ 3128 3129 3130 ];

  systemd.services.squid.preStart = ''
    test -e /var/cache/squid/ssl_db || ${pkgs.squid}/libexec/security_file_certgen -c -s /var/cache/squid/ssl_db -M 4MB
  '';
}
