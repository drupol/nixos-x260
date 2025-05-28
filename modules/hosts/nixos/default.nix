{
  config,
  ...
}:
{
  unify.hosts.nixos.nixos = {
    users.pol.modules = config.unify.hosts.nixos.nixos.modules;

    modules = with config.unify.modules; [
      base
      ai
      facter
      openssh
      shell
      vpn
    ];

    tags = [
      "base"
      "ai"
      "facter"
      "openssh"
      "shell"
      "vpn"
    ];

    fqdn = "nixos.netbird.cloud";
  };
}
