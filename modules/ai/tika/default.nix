{
  unify.modules.ai.nixos = {
    services = {
      tika = {
        enable = true;
        configFile = ./tika-config.xml;
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
    ];
  };
}
