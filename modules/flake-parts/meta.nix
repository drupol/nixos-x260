{ lib, ... }:
{
  options.flake.meta = lib.mkOption {
    type = with lib.types; lazyAttrsOf anything;
  };

  config.flake.meta.uri = "github:drupol/nixos-x260";
}
