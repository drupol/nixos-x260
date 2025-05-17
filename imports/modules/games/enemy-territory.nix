{
  unify.modules.games.home =
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
}
