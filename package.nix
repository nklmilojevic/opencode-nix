{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.3";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "19mr0wc40l43hl9r8cirnyc5jv7qkbc3lffnrhh18sgbclrbr9p3";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1bs68692g5j0fbzx3mvv78c2ls2ramwiliqfbgb70my9p3ksf9dk";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "06bar4s5wkdamip4gpipfj4jhrnlijv42n1wjpqx1ym3v8my0xbh";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "17hi7rdq6865hpasgrv9kany615cn8qkmsc2pywkavv74x5413sr";
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
