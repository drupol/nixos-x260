{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/activation/system-report-changes.nix
    ../common/configuration.nix
    ../common/packages.nix
    ../common/packages-desktop.nix
    ../../modules/users
    ./configuration.nix
    ./home.nix
  ];
}
