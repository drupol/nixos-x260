{
  config,
  ...
}:
{
  unify.hosts.nixos.x260 = {
    users.pol.modules = config.unify.hosts.nixos.x260.modules;

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

    fqdn = "x260.netbird.cloud";
  };
}
