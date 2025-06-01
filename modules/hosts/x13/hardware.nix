{
  inputs,
  ...
}:
{
  flake.modules = {
    hosts.x13 = {
      imports = with inputs.nixos-hardware.nixosModules; [
        common-pc-ssd
      ];
    };
  };
}
