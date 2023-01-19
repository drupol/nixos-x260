{
  config,
  pkgs,
  self,
  host,
  ...
}: {
  imports = [
    ../../activation/system-report-changes.nix
    ../common/config.nix
    ../../users
    ./configuration.nix
    ./packages.nix
  ];
}
