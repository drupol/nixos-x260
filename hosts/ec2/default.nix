{ config
, pkgs
, self
, hostConfig
, ...
}: {
  imports = [
    ../common/configuration.nix
    ../../modules/users
    ./configuration.nix
  ];
}
