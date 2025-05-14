{
  unify.modules.work.home =
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
