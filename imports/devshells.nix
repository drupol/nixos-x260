{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShellNoCC { packages = [ ]; };
      };
    };
}
