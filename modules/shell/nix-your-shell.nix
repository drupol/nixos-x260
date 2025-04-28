{
  flake.modules = {
    homeManager.shell = {
      programs = {
        nix-your-shell = {
          enable = true;
          enableNushellIntegration = false;
          enableZshIntegration = false;
        };
      };
    };
  };
}
