{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
    inputs.make-shell.flakeModules.default
  ];

  perSystem =
    { config, ... }:
    {
      pre-commit.check.enable = false;
      make-shells.default.shellHook = config.pre-commit.installationScript;
    };
}
