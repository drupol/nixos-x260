{
  flake.modules.homeManager.work =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        aws-workspaces
      ];
    };

  nixpkgs.allowedUnfreePackages = [
    "aws-workspaces"
  ];
}
