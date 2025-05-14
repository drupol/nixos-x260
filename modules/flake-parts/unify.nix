{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.unify.flakeModule
  ];

  unify.options = {
    fqdn = lib.mkOption {
      type = lib.types.str;
    };

    tags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of tags to apply to the system.";
    };
  };
}
