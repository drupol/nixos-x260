{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          packages = [
            pkgs.nil
            pkgs.nixd
            pkgs.nixfmt-rfc-style
          ];
        };
      };
    };
}
