{
  flake.modules.nixos."hosts/x280" = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/89a4586a-eefb-4dd4-bf06-3953902edc1e";
      fsType = "ext4";
    };

    fileSystems."/boot/efi" = {
      device = "/dev/disk/by-uuid/155B-2355";
      fsType = "vfat";
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/ce407b75-260e-47f0-822e-1984866571db";
      fsType = "ext4";
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/c56d5d01-df37-471e-8827-dc193ceb182b";
      fsType = "ext4";
    };

    swapDevices = [ { device = "/dev/disk/by-uuid/005040e5-7773-438e-8ede-f3f63a242d7d"; } ];
  };
}
