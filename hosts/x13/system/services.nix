{ ... }:
{
  services = {
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
    };
    thermald.enable = true;
    avahi.enable = true;
  };
}
