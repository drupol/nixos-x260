{
  flake.modules =
    let
      stateVersion = "25.05";
    in
    {
      homeManager.base = {
        home = {
          inherit stateVersion;
        };
      };

      nixos.base = {
        system = {
          # This value determines the NixOS release from which the default
          # settings for stateful data, like file locations and database versions
          # on your system were taken. It‘s perfectly fine and recommended to leave
          # this value at the release version of the first install of this system.
          # Before changing this value read the documentation for this option
          # (e.g. man configuration.nix or on https://search.nixos.org/options?&show=system.stateVersion&from=0&size=50&sort=relevance&type=packages&query=stateVersion).
          inherit stateVersion;
          rebuild.enableNg = true;
        };
      };
    };
}
