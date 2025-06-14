{
  unify.modules.base.nixos =
    { hostConfig, ... }:
    {
      networking = {
        hostName = hostConfig.name;

        networkmanager = {
          enable = true;
        };

        useDHCP = false;
      };

      systemd = {
        services.NetworkManager-wait-online.enable = false;
        network.wait-online.enable = false;
      };
    };
}
