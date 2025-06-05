{
  flake.modules.nixos.base = {
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
      nscd.enableNsncd = true;
    };
  };
}
