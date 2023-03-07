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
        extraOptions = [
          "--ssh-host=192.168.2.10"
          "--ssh-user=pol"
          "--ssh-auth=publickey"
          "--network=host"
          "--pull=newer"
        ];
      };
    };
  };
}
