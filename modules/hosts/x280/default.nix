{
  config,
  ...
}:
{
  flake.hosts.x280 = {
    modules = {
      inherit (config.flake.modules.nixos)
        base
        x280
        bluetooth
        desktop
        dev
        facter
        fwupd
        shell
        sound
        vpn
        ;
    };
    users = [ "pol" ];
  };
}
