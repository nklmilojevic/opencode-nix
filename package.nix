{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.0";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0mn30jqsaklbidjc9bys95vfcn8lcilf65r0p0b0ygh62fmiyldr";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0z05j4fwldrh5l2n776jlmswjgw9gbvq9wl21c1y1cf0w61zagip";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "00prw8zld3781388cqsk4icgsqn2lr4wz2bb4nbvf3snni54l16j";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1hwpk0lvx20hhxjvf6gh0ijii5h9fhas9hwph9h6g0pm1hkjbjds";
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
