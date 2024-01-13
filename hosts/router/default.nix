{ config
, pkgs
, self
, hostConfig
, ...
}: {
  imports = [
    ../common/configuration.nix
    ../../modules/users
    ./configuration.nix
    ./packages.nix
    ./caddy.nix
    ./home.nix
    ./pi-hole.nix
    ./grafana.nix
    ./prometheus.nix
    ./promtail.nix
  ];
}
