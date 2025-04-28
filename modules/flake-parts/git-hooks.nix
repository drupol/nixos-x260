{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];
  perSystem =
    { config, ... }:
    {
      pre-commit.check.enable = false;
      make-shells.default.shellHook = config.pre-commit.installationScript;
    };
}
