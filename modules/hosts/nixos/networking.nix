{
  unify.hosts.nixos.nixos = {
    networking = {
      interfaces.eno1.useDHCP = true;
    };
  };
}
