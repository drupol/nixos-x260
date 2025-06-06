{
  flake.modules.nixos."hosts/nixos" = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/7bb30cda-a7fd-4f83-9cea-a4a80ede8a6e";
      fsType = "ext4";
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/661a3104-2529-42d8-85fa-36249b1fda5d";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/1f4fd44f-280a-452a-9a48-e0b8e402e680";
      fsType = "ext4";
    };

    swapDevices = [ { device = "/dev/disk/by-uuid/87129bb6-05de-4828-8031-2673a2be7ed4"; } ];
  };
}
