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
      pi-hole = {
        autoStart = true;
        image = "wettyoss/wetty:latest";

        ports = [
          "3000:3000"
        ];
      };
    };
  };
}
