{
  flake.modules.nixos.root =
    { pkgs, ... }:
    {
      users.users.root = {
        shell = pkgs.fish;
        initialPassword = "id";
      };
    };
}
