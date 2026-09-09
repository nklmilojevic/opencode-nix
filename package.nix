{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.30";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1pp65y362bx3pqyrvr15n66kj273q8qlysic62x3riz5ikkafcda";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0bd3ndpsvsgps6nmgzvn6kmb8k3ls8apbgnrbhg7rfxgfrpbc80y";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "147m41ifc58lsgf9036a0bbx22cr89fv61vg2z0qdkxsmp89n4fp";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1y77fhb32xbpbg37ihic969a7i8xvib127jhnsyawilcvky25dr5";
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
