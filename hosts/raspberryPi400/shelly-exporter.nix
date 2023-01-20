{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "shelly_exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "aexel90";
    repo = pname;
    rev = "91e06f8c9dab20853b5685ca43d5081109c03d46";
    sha256 = "sha256-L0TuBDq5eEahQvzqd1WuvmXuQbbblCM+Nvj15IybnVo=";
  };

  vendorSha256 = "sha256-BCrge2xLT4b4wpYA+zcsH64a/nfV8+HeZF7L49p2gEw=";

  meta = with lib; {
    description = "Shelly humidity sensor exporter for prometheus";
    homepage = "https://github.com/aexel90/shelly_exporter";
    maintainers = with maintainers; [drupol];
  };
}
