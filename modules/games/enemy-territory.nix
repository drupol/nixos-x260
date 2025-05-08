{
  flake.modules = {
    homeManager.games =
      { pkgs, ... }:
      {
        nixpkgs.config = {
          allowBroken = true;
          allowUnfree = true;
        };

        home.packages = with pkgs; [
          etlegacy
        ];
      };
  };
}
