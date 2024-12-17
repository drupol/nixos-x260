{ ... }:
{

  perSystem =
    { config, ... }:
    {
      pkgsDirectory = ../pkgs/by-name;
      overlayAttrs = config.packages;
    };
}
