{
  config,
  ...
}:
{
  unify.hosts.x260.nixos = {
    users.pol.modules = config.unify.hosts.x260.nixos.modules;

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
