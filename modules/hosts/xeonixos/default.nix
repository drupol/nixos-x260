{
  config,
  ...
}:
{
  flake.hosts.xeonixos = {
    modules = {
      inherit (config.flake.modules.nixos)
        base
        xeonixos
        desktop
        dev
        facter
        guacamole
        shell
        sshd
        virtualisation
        vpn
        ;
    };
    users = [ "pol" ];
  };
}
