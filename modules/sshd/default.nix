{
  flake.modules = {
    nixos.sshd = {
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
  };
}
