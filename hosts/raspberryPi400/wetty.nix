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
          "--network=host"
          "--pull=newer"
        ];
        environment = {
          FORCESSH = "true";
          SSHUSER = "pol";
          SSHHOST = "192.168.2.10";
          SSHAUTH = "publickey";
          SSHKEY = "/id_rsa";
        };
        volumes = [
          "/home/pol/nix/id_rsa:/id_rsa"
        ];
      };
    };
  };
}
