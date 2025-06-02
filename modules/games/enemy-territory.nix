{
  flake.modules = {
    homeManager.games =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          etlegacy
        ];
      };
  };

  nixpkgs.allowedUnfreePackages = [
    "etlegacy"
  ];
}
