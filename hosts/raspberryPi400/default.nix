{
  config,
  pkgs,
  self,
  host,
  ...
}: {
  imports = [
    ../common/configuration.nix
    ../common/fonts.nix
    ../../modules/users
    ./configuration.nix
    ./packages.nix
    #./headscale.nix
    ./caddy.nix
    ./squid.nix
    ./home.nix
  ];
}
