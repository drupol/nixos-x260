{
  config,
  ...
}:
{
  unify.hosts.nixos.x13 = {
    users = {
      pol.modules = config.unify.hosts.nixos.x13.modules;
    };

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
      root
      shell
      sound
      virtualisation
      vpn
      work
    ];

    tags = [
      "desktop"
      "laptop"
    ];
  };
}
