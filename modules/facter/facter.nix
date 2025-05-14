{ inputs, ... }:
{
  unify.modules.facter.nixos = {
    imports = [ inputs.nixos-facter-modules.nixosModules.facter ];
    facter.detected.dhcp.enable = false;
  };

  unify.modules.facter.home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ nixos-facter ];
    };
}
