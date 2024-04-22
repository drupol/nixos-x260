{ ... }: {
  services = {
    flatpak = {
      enable = false;
    };
    fwupd = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "gb";
        options = "eurosign:e";
      };
      videoDrivers = [ "displaylink" ];
    };
    thermald.enable = true;
    avahi.enable = true;
    guix.enable = true;
    # Limit the systemd journal to 100 MB of disk or the
    # last 3 days of logs, whichever happens first.
    journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=3day
    '';
  };
}
