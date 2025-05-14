{
  unify.modules.sshd.nixos = {
    services = {
      openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          X11Forwarding = true;
        };
      };
    };
  };
}
