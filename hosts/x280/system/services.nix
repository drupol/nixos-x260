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
        layout = "be";
        options = "eurosign:e";
      };
    };
    thermald.enable = true;
    avahi.enable = true;
  };
}
