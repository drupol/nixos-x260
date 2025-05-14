{
  unify.modules.dev.home =
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

  nixpkgs.allowedUnfreePackages = [
    "gh-copilot"
  ];
}
