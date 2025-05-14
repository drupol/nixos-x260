{ inputs, lib, ... }:
{
  imports = [
    inputs.unify.flakeModule
  ];

  unify.options = {
    fqdn = lib.mkOption {
      type = lib.types.str;
    };
  };
}
