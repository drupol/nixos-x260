{
  unify.modules.dev.home =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.mergiraf
      ];
    };
}
