{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.5";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1gbmjvam9iy9w476kavm30pq9fxpnp99zapn6x7f34z79md0bmqi";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "05pway0ym0wbwdd5z3ysxaz0r5r0k6gbsj9wycw4myp40a9ixz02";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1im9c77k7h5cvmx510qjqwn6kr38iha6w0x7srybynibr7xjqyqm";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0s3pqsiyirha1v3x3b1gfvrxwhqpla3p6yzwvgcbb4r3p5fcmdrh";
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
