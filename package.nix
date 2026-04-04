{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.15";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1c4zvf917j284sj4ha0hvqyagzjhdmkcmwjsq13cfgl704dhi8v2";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "03rlcqn53kyxccs7ibyjilfi6sk7hbs7ia90j2hxi8lkfcyq8fbs";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1ydbph7k2xchcxxgsyj7l5lvhywqvpp5q2zpj4h31v217m3cmf38";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "02hqqbn7ywknpg4qzbhzlg5gxbl81lmf9w28k3f8jydikwqnzy95";
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
