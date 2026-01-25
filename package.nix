{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.35";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0d5wr01biqxi20ylxsyvnq3j3dj2sa5c8ibm67wnxjc7jcyf3fya";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0n8z05vxj1j6cp7vpmg1dc0mm2zy1z2zj2clv0mvj8bxn87hga21";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "06381vjknwh6sbz4461657pav63kdkdgpl8rwvlnf0lnzy21lqsx";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0pmrxnyms0dzc12gi4qp17bqcyafz0fjj3sih0c77v2kr9d30lq4";
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
