{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.4";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1nw0g48hf8nzps711z2rd77b9yqsj3v1hhcxm47r2g40n6fsaxyq";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "05570smaf6wzx883c9r24cmfip209sb3djzs8mcbj6fg4cfwwyp6";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "07hgygq73yr736w0jn567ix2nhrfkqxyxw86nm54myk9yw29kird";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0j5wm5zb4i0835s9fqrxy2gfxwgllcm59i8ccy5f8m0m3cj89bj2";
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
