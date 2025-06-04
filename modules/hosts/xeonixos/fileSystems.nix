{
  flake.modules.nixos."hosts/xeonixos" = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/6fb8e36f-069c-43db-a843-1e345b17ec04";
      fsType = "ext4";
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/f70058b0-0600-4a7c-a226-37bf10eb307d"; }
    ];

  };
}
