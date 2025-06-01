{
  flake.modules = {
    nixosUsers.root =
      { pkgs, ... }:
      {
        users.users.root = {
          shell = pkgs.fish;
          initialPassword = "id";
        };
      };
  };
}
