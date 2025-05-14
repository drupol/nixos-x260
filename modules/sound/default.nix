{
  unify.modules.sound.nixos = {
    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };

    users.users.pol = {
      extraGroups = [
        "sound"
        "audio"
      ];
    };
  };
}
