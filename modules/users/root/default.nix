{
  flake.modules = {
    nixos.base =
      { pkgs, ... }:
      {
        users.users.root = {
          shell = pkgs.fish;
          initialPassword = "id";
        };
      };
  };
}
