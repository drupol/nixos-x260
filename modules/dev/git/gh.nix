{
  flake.modules = {
    homeManager.dev =
      { pkgs, ... }:
      {
        programs = {
          gh = {
            enable = true;
            extensions = [
              pkgs.gh-copilot
            ];
          };
        };
      };
  };

  nixpkgs.allowedUnfreePackages = [
    "gh-copilot"
  ];
}
