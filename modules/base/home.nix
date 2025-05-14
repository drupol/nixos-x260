{
  unify.modules.base.home =
    { config, ... }:
    {
      programs.home-manager.enable = true;
      # See https://ohai.social/@rycee/112502545466617762
      # See https://github.com/nix-community/home-manager/issues/5452
      systemd.user.startServices = "sd-switch";

      home.file = {
        ".face" = {
          source = ../../files/home/pol/.face;
          recursive = true;
        };
        ".face.icon" = {
          source = ../../files/home/pol/.face;
          recursive = true;
        };
        "${config.xdg.configHome}/.password-store/.keep" = {
          text = "";
          recursive = true;
        };
        # Credits to https://store.kde.org/p/1272202
        "Pictures/Backgrounds/" = {
          source = ../../files/home/pol/Pictures/Backgrounds;
          recursive = true;
        };
      };

      services = {
        home-manager.autoExpire = {
          enable = true;
          frequency = "weekly";
          store.cleanup = true;
        };
        gpg-agent = {
          enable = true;
          enableSshSupport = true;
          sshKeys = [ "143BC4FB7B3AC7C4F902ADCB579D2F66CDA1844A" ];
        };
      };
    };
}
