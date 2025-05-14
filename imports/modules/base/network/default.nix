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

      users.users.pol = {
        extraGroups = [
          "networkmanager"
        ];
      };
    };
}
