{ pkgs, ... }:
{
  nix = {
    # See https://discourse.nixos.org/t/24-05-add-flake-to-nix-path/46310/9
    # See https://hachyderm.io/@leftpaddotpy/112539055867932912
    channel.enable = false;
    settings.nix-path = [ "nixpkgs=${pkgs.path}" ];

    # From https://jackson.dev/post/nix-reasonable-defaults/
    extraOptions = ''
      connect-timeout = 5
      log-lines = 50
      min-free = 128000000
      max-free = 1000000000
      fallback = true
      warn-dirty = false
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
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
}
