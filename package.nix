{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.8";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1bqlcdzlm8y8fagchg70nwrx9bi30f2il4qink9f8h48j4v8pxc4";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0qhwadib3psr84xj36lfzrbbiwsvwihnq6q8qdaxp33f6z2vczsj";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1k0g4acb1n2x1iqpv5657b8ir9pqq9qh8m0l4j411khm1yxmykjl";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1zdpygj9ndjrfxbn6p6zqgj00amadddcpqgaasigr63zr6mjyjc5";
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
