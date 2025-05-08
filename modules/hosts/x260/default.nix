{
  config,
  ...
}:
{
  flake.hosts.x260 = {
    modules = {
      inherit (config.flake.modules.nixos)
        base
        x260
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
