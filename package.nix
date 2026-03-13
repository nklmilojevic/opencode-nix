{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.26";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1xlsfm7nr8bmzs7b2m0fz3arnzlzk14n0k2gm3nqwbvvhpfmazfk";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "05fzmhl1jcdh3grca88pmrkf590z2y87bzi901via9p6mwjp26x2";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1h4a45xdj3kpr596j2xiwdlz91ai49svrxq11caqp4ycmqb5v4gi";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0riqvhbxrj2arxg17s5crxdcg020bdamapmy59ls39laljk9fwf0";
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
