{
  config,
  ...
}:
{
  flake.hosts.x13 = {
    modules = {
      inherit (config.flake.modules.nixos)
        base
        x13
        bluetooth
        desktop
        displaylink
        dev
        facter
        fwupd
        games
        shell
        sound
        vpn
        virtualisation
        ;
    };
    users = [ "pol" ];
  };
}
