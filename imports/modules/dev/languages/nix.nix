{
  unify.modules.dev.home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixpkgs-review
      ];
    };
}
