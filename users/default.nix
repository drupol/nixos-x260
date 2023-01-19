{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./root.nix
    ./pol.nix
  ];

  users.mutableUsers = false;
}
