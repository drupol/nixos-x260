{ pkgs
, self
, hostConfig
, config
, lib
, ...
}: {
  programs = {
    lazygit = {
      enable = true;
    };
  };
}
