{
  unify.hosts.nixos.x13.nixos = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        efi.efiSysMountPoint = "/boot/efi";
      };

      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "thunderbolt"
          "nvme"
          "usb_storage"
          "sd_mod"
        ];
      };

      kernelModules = [ "kvm-intel" ];
    };
  };
}
