{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.47";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0aaflin4vq8ny8d1lyyw599s0z3cnd5ly8ysmqgh4xfjbmcvq541";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1q4lxaqvxgb4j310mir9c96j0jyq69q8r4hphzwi58lapv1qspq2";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0199l55rrfq8x6c5krzkha28a71kav5km69zgxk4vbvbxgp77s07";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0r364fry9c5w7dz7324x20szg1mi91f0ir0jmvqmzfhrzvib9n1z";
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
