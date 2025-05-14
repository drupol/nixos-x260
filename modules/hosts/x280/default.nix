{
  config,
  ...
}:
{
  unify.hosts.nixos.x280 = {
    users.pol.modules = config.unify.hosts.nixos.x280.modules;

    modules = with config.unify.modules; [
      base
      bluetooth
      desktop
      dev
      facter
      fwupd
      pol
      shell
      sound
      vpn
    ];

    tags = [
      "base"
      "bluetooth"
      "desktop"
      "dev"
      "facter"
      "fwupd"
      "shell"
      "sound"
      "vpn"
    ];

    fqdn = "x280.netbird.cloud";
  };
}
