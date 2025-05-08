{
  flake.modules.nixos.nixos = {
    networking = {
      interfaces.eno1.useDHCP = true;
    };
  };
}
