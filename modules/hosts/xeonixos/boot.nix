{
  lib,
  ...
}:
{
  flake.modules.nixos."hosts/xeonixos" = {
    boot = {
      # Use the GRUB 2 boot loader.
      loader.grub.enable = true;
      loader.grub.device = "/dev/sdb";
      loader.grub.useOSProber = false;

      # boot.loader.grub.efiSupport = true;
      # boot.loader.grub.efiInstallAsRemovable = true;
      # boot.loader.efi.efiSysMountPoint = "/boot/efi";
      kernel = {
        sysctl = {
          "net.ipv4.conf.all.forwarding" = lib.mkForce true;
          "net.ipv6.conf.all.forwarding" = lib.mkForce true;
        };
      };

      initrd.availableKernelModules = [
        "ehci_pci"
        "ahci"
        "xhci_pci"
        "firewire_ohci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];

      kernelModules = [ "kvm-intel" ];
    };
  };
}
