{
  flake.modules.nixos."hosts/nixos" = {
    networking = {
      interfaces.eno1.useDHCP = true;
    };
  };
}
