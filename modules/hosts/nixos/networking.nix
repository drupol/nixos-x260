{
  flake.modules.hosts.nixos = {
    networking = {
      interfaces.eno1.useDHCP = true;
    };
  };
}
