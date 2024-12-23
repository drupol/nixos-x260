{ ... }:
{
  virtualisation = {
    podman = {
      defaultNetwork.settings = {
        dns_enabled = true;
      };
      dockerCompat = true;
      dockerSocket.enable = true;
      enable = true;
    };
    docker = {
      enable = true;
      daemon.settings = {
        data-root = "/home/pol/.var/lib/docker";
        features = {
          "containerd-snapshotter" = true;
        };
      };
      enableOnBoot = true;
    };
  };
}
