{
  flake.modules.nixos.base.boot = {
    initrd.systemd.enable = true;

    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };
}
