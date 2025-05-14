{
  unify.modules.base.nixos =
    { pkgs, ... }:
    {
      users.users.root = {
        shell = pkgs.fish;
        initialPassword = "id";
      };
    };
}
