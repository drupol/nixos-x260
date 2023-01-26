{
  config,
  pkgs,
  self,
  host,
  ...
}: {
  imports = [
    ../../modules/activation/system-report-changes.nix
    ../common/configuration.nix
    ../../modules/users
    ./configuration.nix
  ];
}
