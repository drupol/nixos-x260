{
  config,
  ...
}:
{
  flake.hosts.nixos = {
    modules = {
      inherit (config.flake.modules.nixos)
        base
        nixos
        ai
        dev
        facter
        shell
        sshd
        vpn
        ;
    };
    users = [ "pol" ];
  };
}
