{
  config,
  ...
}:
{
  unify.hosts.nixos.x13 = {
    users.pol.modules = config.unify.hosts.nixos.x13.modules;

    modules = with config.unify.modules; [
      base
      desktop
      dev
      email
      facter
      fwupd
      games
      messaging
      pol
      shell
      sound
      virtualisation
      vpn
      virtualisation
      work
    ];

    tags = [
      "desktop"
      "laptop"
    ];

    fqdn = "x13.netbird.cloud";
  };
}
