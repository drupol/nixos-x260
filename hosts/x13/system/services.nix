{ ... }:
{
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
  };
}
