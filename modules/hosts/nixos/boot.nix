{
  lib,
  ...
}:
{
  flake.modules.nixos."hosts/nixos" = {
    boot = {
      # Use the GRUB 2 boot loader.
      loader.grub.enable = true;
      # boot.loader.grub.efiSupport = true;
      # boot.loader.grub.efiInstallAsRemovable = true;
      # boot.loader.efi.efiSysMountPoint = "/boot/efi";
      # Define on which hard drive you want to install Grub.
      loader.grub.device = "/dev/sda"; # or "nodev" for efi only
      kernel = {
        sysctl = {
          "net.ipv4.conf.all.forwarding" = lib.mkForce true;
          "net.ipv6.conf.all.forwarding" = lib.mkForce true;
        };
      };

      initrd.availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sr_mod"
      ];

      kernelModules = [ "kvm-intel" ];
    };
  };
}
