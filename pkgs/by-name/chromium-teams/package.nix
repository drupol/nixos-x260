{
  makeDesktopItem,
  lib,
  stdenvNoCC,
  makeBinaryWrapper,
  chromium,
  copyDesktopItems,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chromium-teams";
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
      --add-flags "--user-data-dir=\$XDG_CONFIG_HOME/chromium-teams" \
      --add-flags "--app=https://teams.microsoft.com"
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "teams";
      exec = "teams";
      icon = "teams";
      desktopName = "Teams";
      genericName = finalAttrs.meta.description;
      categories = [
        "Network"
        "InstantMessaging"
      ];
      mimeTypes = [ "x-scheme-handler/msteams" ];
    })
  ];

  meta = {
    description = "Microsoft Teams";
    homepage = "https://discord.com";
    license = lib.licenses.unfree;
    mainProgram = "teams";
    maintainers = with lib.maintainers; [ ];
    platforms = chromium.meta.platforms;
  };
})
