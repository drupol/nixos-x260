{ ... }:
{
  virtualisation = {
    oci-containers.backend = "podman";

    containers.registries.search = [
      "docker.io"
    ];

    containers.storage.settings = {
      storage = {
        driver = "overlay";
        graphroot = "/home/pol/.podman/var/lib/containers/storage";
        runroot = "/home/pol/.podman/run/containers/storage";
      };
    };

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
}
