{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.32";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1pn1w15h7jphcwikvr5zf1k96aak1gxwpbc4y320jrxqbv40626s";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0090kgipn8l6259hj9lfjrag4kqrp31ib4989lid368flxhjvar9";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "11hkb0xnsm22jv8j2wnz541pbg8rf4miyill2fr57jvkz20wvh79";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1gnypcmg6xpmw151jzr2zh6zg2hbb3qrfh0wa35crslxrjv7nw51";
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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
