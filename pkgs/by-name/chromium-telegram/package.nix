{
  makeDesktopItem,
  lib,
  stdenvNoCC,
  makeBinaryWrapper,
  chromium,
  copyDesktopItems,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chromium-telegram";
  version = "1.0.0";

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
    makeWrapper ${chromium}/bin/chromium $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer" \
      --add-flags "--ozone-platform=wayland" \
      --add-flags "--user-data-dir=\$XDG_CONFIG_HOME/chromium-telegram" \
      --add-flags "--app=https://web.telegram.org"
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "telegram";
      exec = "telegram";
      icon = "telegram";
      desktopName = "Telegram";
      genericName = finalAttrs.meta.description;
      categories = [
        "Network"
        "InstantMessaging"
      ];
    })
  ];

  meta = {
    description = "Telegram";
    homepage = "https://telegram.org";
    license = lib.licenses.unfree;
    mainProgram = "telegram";
    maintainers = with lib.maintainers; [ ];
    platforms = chromium.meta.platforms;
  };
})
