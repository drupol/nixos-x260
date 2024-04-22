{ ... }: {
  virtualisation = {
    podman = {
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
