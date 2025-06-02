{
  inputs,
  ...
}:
{
  flake.modules = {
    homeManager.messaging =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          inputs.self.overlays.default
        ];

        home.packages = [
          pkgs.local.chromium-discord
          pkgs.local.chromium-element
          pkgs.local.chromium-meet
          pkgs.local.chromium-protonmail
          pkgs.local.chromium-teams
          pkgs.local.chromium-telegram
          pkgs.signal-desktop
        ];
      };

  };
}
