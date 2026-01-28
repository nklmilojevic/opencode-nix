{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.39";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0pqa6xm1gdvkl61m0amm8mx0bn1y544g46nqa3gkqndq03yrmlw7";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0i577dhd7a4q0xvmb7p5n1zap7w4kahb3282vansawyg7j89nqyl";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1nlfwmrvwgi8hw2vkmvi6vxfkwn06qpcmdqncvinn68p3mcx6qjr";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1k4pmhs3a2fiygbn42kv7x49kivg2pdvzp4jnn9dq4c9g3qcm86f";
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
