{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.20";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0kksgxhsajvq2rhyic7hlaj4c8fk4by8dl2a3vz0bm3c0l089qgp";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "04mw8llgl952fnjbaiyw05ha00kygadfnpd3fag1f228ifsag299";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "014i72cpjm6az2kxh0zkc0y9cyxzagfsiqqiklp8x9wzfn26cnil";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1xsm9jjd2a39ysisq53zh2fl14v83m2k27mfcv02d469ilcc34ah";
    };
  };

  currentPlatform = platformInfo.${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

in stdenv.mkDerivation {
  pname = "opencode";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/opencode-${currentPlatform.platform}/-/opencode-${currentPlatform.platform}-${version}.tgz";
    sha256 = currentPlatform.sha256;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/opencode $out/bin/opencode
    chmod +x $out/bin/opencode

    runHook postInstall
  '';

  meta = with lib; {
    description = "OpenCode - AI-powered coding assistant in your terminal";
    homepage = "https://github.com/anomalyco/opencode";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "opencode";
  };
}
