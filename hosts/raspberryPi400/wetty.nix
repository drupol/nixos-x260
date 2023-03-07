{
  pkgs,
  lib,
  ...
}: {
  virtualisation = {
    containers = {
      enable = true;
    };

    oci-containers.backend = "docker";
    oci-containers.containers = {
      wetty = {
        autoStart = true;
        image = "wettyoss/wetty:latest";

        ports = [
          "3000:3000"
        ];
      };
    };
  };
}
