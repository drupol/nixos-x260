{
  unify.modules.games.home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        etlegacy
      ];
    };

  nixpkgs.allowedUnfreePackages = [
    "etlegacy"
  ];
}
