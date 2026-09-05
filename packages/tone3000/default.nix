{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  alsa-lib,
  curl,
  fontconfig,
  freetype,
  glib,
  glib-networking,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  libxscrnsaver,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tone3000";
  version = "0.0.5";

  src = fetchurl {
    url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${finalAttrs.version}/TONE3000-v${finalAttrs.version}-linux-x64.tar.gz";
    hash = "sha256-Hqe0PrLZrPXjsLsdXS+yqWzDM+uYkWBlJ0jncb3hAB4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    freetype
    stdenv.cc.cc.lib
    libx11
  ];

  # Runtime dependencies dlopened by JUCE and WebKitGTK:
  # - webkitgtk_4_1 & gtk3: UI webview
  # - libsoup_3 & curl: network operations and tone model downloads
  # - glib & glib-networking: GIO / TLS networking backend
  # - X11 extension libraries dlopened by JUCE (libXcursor, libXext, libXinerama, libXrandr, libXss)
  runtimeDependencies = [
    alsa-lib
    curl
    fontconfig
    freetype
    glib
    glib-networking
    gtk3
    libsoup_3
    webkitgtk_4_1
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
    libxscrnsaver
  ];

  appendRunpaths = [
    (lib.makeLibraryPath [
      alsa-lib
      curl
      fontconfig
      freetype
      glib
      glib-networking
      gtk3
      libsoup_3
      webkitgtk_4_1
      libx11
      libxcursor
      libxext
      libxinerama
      libxrandr
      libxscrnsaver
    ])
  ];

  installPhase = ''
    runHook preInstall

    # Install standalone application
    install -Dm755 TONE3000 $out/bin/TONE3000

    wrapProgram $out/bin/TONE3000 \
      --set GIO_EXTRA_MODULES "${glib-networking}/lib/gio/modules"

    # Install plugins (CLAP, VST3, LV2)
    install -Dm755 TONE3000.clap $out/lib/clap/TONE3000.clap

    mkdir -p $out/lib/vst3 $out/lib/lv2
    cp -r TONE3000.vst3 $out/lib/vst3/
    cp -r TONE3000.lv2 $out/lib/lv2/

    # Install factory presets
    mkdir -p $out/share/TONE3000/Presets/Factory
    if [ -d factory-presets ]; then
      cp -r factory-presets/*.t3kpreset $out/share/TONE3000/Presets/Factory/
    fi

    # Install icon
    install -Dm644 tone3000.png $out/share/icons/hicolor/512x512/apps/tone3000.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "tone3000";
      exec = "TONE3000";
      icon = "tone3000";
      desktopName = "TONE3000";
      genericName = "Neural Amp Modeler & IR Player";
      comment = "Play NAM captures and IRs straight from TONE3000";
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
      ];
      startupWMClass = "TONE3000";
    })
  ];

  meta = {
    description = "Neural Amp Modeler (NAM) and IR player plugin & standalone app";
    homepage = "https://github.com/tone-3000/tone3000-plugin";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "TONE3000";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
