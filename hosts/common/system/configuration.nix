{ lib, pkgs, ... }:
{
  # See https://github.com/NixOS/nixpkgs/pull/308801
  system.switch = { enable = false; enableNg = true; };

  boot = {
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_BE.UTF-8";
    LC_IDENTIFICATION = "fr_BE.UTF-8";
    LC_MEASUREMENT = "fr_BE.UTF-8";
    LC_MONETARY = "fr_BE.UTF-8";
    LC_NAME = "fr_BE.UTF-8";
    LC_NUMERIC = "fr_BE.UTF-8";
    LC_PAPER = "fr_BE.UTF-8";
    LC_TELEPHONE = "fr_BE.UTF-8";
    LC_TIME = "fr_BE.UTF-8";
  };

  # https://mastodon.online/@nomeata/109915786344697931
  documentation.nixos.enable = false;

  systemd.services.NetworkManager-wait-online.enable = false;

  environment.variables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };
}
