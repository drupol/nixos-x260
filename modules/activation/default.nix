# Always add to this file when adding new module
{ inputs
, pkgs
, config
, ...
}: {
  imports = [
    ./system-report-changes.nix
  ];
}
