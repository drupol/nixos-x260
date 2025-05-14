{
  config,
  ...
}:
{
  unify.hosts.x280.nixos = {
    users.pol.modules = config.unify.hosts.x280.nixos.modules;

    modules = with config.unify.modules; [
      base
      bluetooth
      desktop
      dev
      facter
      fwupd
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
