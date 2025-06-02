{
  flake.modules.nixos.ai = {
    services = {
      tika = {
        enable = true;
        configFile = ./tika/tika-config.xml;
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
    ];
  };
}
