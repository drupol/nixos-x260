topLevel@{
  config,
  ...
}:
{
  flake = {
    meta.users = {
      pol = {
        email = "pol.dellaiera@protonmail.com";
        name = "Pol Dellaiera";
        username = "pol";
        key = "0AAF2901E8040715";
        authorizedKeys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfxTd6cA45DZPJsk3TmFmRPu1NQQ0XX0kow18mqFsLLaxiUQX1gsfW1kTVRGNh4s77StdsmnU/5oSQEXE6D8p3uEWCwNL74Sf4Lz4UyzSrsjyEEhNTQJromlgrVkf7N3wvEOakSZJICcpl05Z3UeResnkuZGSQ6zDVAKcB3KP1uYbR4SQGmWLHI1meznRkTDM5wHoiyWJnGpQjYVsRZT4LTUJwfhildAOx6ZIZUTsJrl35L2S81E6bv696CVGPvxV+PGbwGTavMYXfrSW4pqCnDPhQCLElQS4Od1qMicfYRSmk/W2oAKb8HZwFoWQSFUStF8ldQRnPyn2wiBQnhxnczt2jUhq1Uj6Nkq/edb1Ywgn7jlBR4BgRLD3K3oMvzJ/d3xDHjU56jc5lCA6lFLDMBV6Q9DKzMwL2jG3aQbehbUwTz7zbUwAHlCFIY5HGs4d9veXHyCsUikCLPvHL/hQU/vFRHHB7WNEyQJZK+ieOAW+un+1eF88iyKsOXE9y8PjLvXYcPHdzGaQKnqzEJSQcTUw9QSzOZQQpmpy8z6Lf08D2I4GHq1REp6d4krJOOW0gXadjsGEhLqQqWGnHE47QBPnlHlDWzOaf3UX59rFsl8xZDXoXzzwJ1stpeJx+Tn/uSNnaf44yXFyeFK/IDUeOrXYD4fSTLP1P/lCFCfeYqw== (none)"
        ];
      };
    };
  };

  unify.modules.pol.nixos =
    { pkgs, ... }:
    {
      programs.fish.enable = true;

      users.users.pol = {
        description = config.flake.meta.users.pol.name;
        isNormalUser = true;
        createHome = true;
        extraGroups = [
          "audio"
          "input"
          "networkmanager"
          "sound"
          "tty"
          "wheel"
        ];
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = config.flake.meta.users.pol.authorizedKeys;
        initialPassword = "id";
      };

      nix.settings.trusted-users = [ config.flake.meta.users.pol.username ];

      home-manager.users.pol =
        { config, ... }:
        {
          home.file = {
            ".face" = {
              source = ../../../files/home/pol/.face;
              recursive = true;
            };
            ".face.icon" = {
              source = ../../../files/home/pol/.face;
              recursive = true;
            };
            "${config.xdg.configHome}/.password-store/.keep" = {
              text = "";
              recursive = true;
            };
            # Credits to https://store.kde.org/p/1272202
            "Pictures/Backgrounds/" = {
              source = ../../../files/home/pol/Pictures/Backgrounds;
              recursive = true;
            };
          };
        };
    };
}
