{ inputs, ... }:
{
  unify.hosts.x13.nixos = {
    imports = with inputs.nixos-hardware.nixosModules; [
      common-pc-ssd
    ];
  };
}
