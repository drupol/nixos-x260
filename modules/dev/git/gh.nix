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
              pkgs.gh-dash
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
