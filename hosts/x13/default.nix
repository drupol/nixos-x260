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
    ../common/packages.nix
    ../common/packages-desktop.nix
    ../../users
    ./configuration.nix
    ./home.nix
  ];
}
