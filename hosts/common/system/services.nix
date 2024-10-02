{ ... }:
{
  services = {
    flatpak = {
      enable = false;
    };
    fwupd = {
      enable = true;
    };
    # Limit the systemd journal to 100 MB of disk or the
    # last 3 days of logs, whichever happens first.
    journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=3day
    '';
    nscd.enableNsncd = true;
    # needed for store VS Code auth token
    gnome.gnome-keyring.enable = true;
  };
}
