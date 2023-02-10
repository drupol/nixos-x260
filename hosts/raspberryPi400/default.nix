{
  config,
  pkgs,
  self,
  host,
  ...
}: {
  imports = [
    ../common/configuration.nix
    ../../modules/users
    ./configuration.nix
    ./packages.nix
    ./headscale.nix
    ./caddy.nix
  ];
}
