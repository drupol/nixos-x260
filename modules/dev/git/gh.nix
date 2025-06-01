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
            settings = {
              version = "1";
              git_protocol = "ssh";
            };
          };
        };
      };
  };

  nixpkgs.allowedUnfreePackages = [
    "gh-copilot"
  ];
}
