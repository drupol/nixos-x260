{
  fetchurl,
  makeDesktopItem,
  lib,
  stdenvNoCC,
  makeBinaryWrapper,
  chromium,
  copyDesktopItems,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chromium-discord";
  version = "1.0.0";

  src = fetchurl {
    url = "https://discord.com/assets/f9bb9c4af2b9c32a2c5ee0014661546d.png";
    sha256 = "BCS6rXFDD3Zmrpmm/3zhVTvPBev+Ld2dgP/7wewWQaI=";
  };

  buildInputs = [ chromium ];

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/pixmaps}
    ln -s ${finalAttrs.src} $out/share/pixmaps/discord.png

    makeWrapper ${chromium}/bin/chromium $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer" \
      --add-flags "--ozone-platform=wayland" \
      --add-flags "--user-data-dir=\$XDG_CONFIG_HOME/discord-chromium" \
      --add-flags "--app=https://discord.com/app"
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "discord";
      exec = "discord";
      icon = "discord";
      desktopName = "discord";
      genericName = finalAttrs.meta.description;
      categories = [
        "Network"
        "InstantMessaging"
      ];
      mimeTypes = [ "x-scheme-handler/discord" ];
    })
  ];

  meta = {
    description = "All-in-one cross-platform voice and text chat for gamers";
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
    mainProgram = "discord";
    maintainers = with lib.maintainers; [ ];
    platforms = chromium.meta.platforms;
  };
})
