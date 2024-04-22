{ ... }: {
  services = {
    flatpak = {
      enable = false;
    };
    # Limit the systemd journal to 100 MB of disk or the
    # last 3 days of logs, whichever happens first.
    journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=3day
    '';
    fstrim.enable = true;
    nscd.enableNsncd = true;
    # needed for store VS Code auth token
    gnome.gnome-keyring.enable = true;
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
      };
    };
  };
}
