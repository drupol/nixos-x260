{
  unify.modules.virtualisation.nixos = {
    virtualisation = {
      oci-containers.backend = "podman";

      containers.registries.search = [
        "docker.io"
      ];

      podman = {
        enable = true;
        defaultNetwork.settings = {
          dns_enabled = true;
        };
        dockerCompat = true;
        dockerSocket.enable = true;

        autoPrune = {
          enable = true;
          flags = [ "--all" ];
          dates = "weekly";
        };
      };
    };

    users.users.pol = {
      extraGroups = [
        "podman"
      ];
    };
  };
}
