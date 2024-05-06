{ pkgs, ... }:
{
  nix = {
    # From https://jackson.dev/post/nix-reasonable-defaults/
    extraOptions = ''
      connect-timeout = 5
      log-lines = 25
      min-free = 128000000
      max-free = 1000000000
      fallback = true
      warn-dirty = false
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
    # nix repl "/etc/nix/inputs/nixpkgs"
    nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
    registry = {
      nixpkgs.to = {
        type = "path";
        path = pkgs.path;
      };
    };
    settings = {
      trusted-users = [
        "root"
        "pol"
      ];
      auto-optimise-store = true;
      extra-substituters = [ "https://cache.lix.systems" ];
      trusted-public-keys = [ "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: true;
    };
  };

  environment.etc."nix/inputs/nixpkgs".source = pkgs.path;
}
