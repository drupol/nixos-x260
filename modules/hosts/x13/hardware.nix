{
  inputs,
  ...
}:
{
  unify.hosts.nixos.x13.nixos = {
    imports = with inputs.nixos-hardware.nixosModules; [
      common-pc-ssd
    ];
  };
}
