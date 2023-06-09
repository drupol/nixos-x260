{ config
, pkgs
, ...
}: {
  users.users.root.shell = pkgs.fish;
  users.users.root.initialHashedPassword = "";
}
