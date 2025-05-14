{
  unify.modules.work.home =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;

      home.packages = with pkgs; [
        aws-workspaces
      ];
    };
}
