{
  pkgs,
  config,
  ...
}: {
  networking = {
    firewall = {
      allowedTCPPorts = [443];
    };
  };

  services.caddy = {
    enable = true;
  };
}
