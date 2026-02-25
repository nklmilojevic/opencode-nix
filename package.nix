{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.14";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1wgh01m1dz7lg67w9mp556v0804npwr0ncz1g82gcxys2qapkwv7";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "04bnh3glkgc64fmq1s7y1siy0jc1l7mx10rjl47cvh88j85rhvf6";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1cdvfas20wspgmyy5mzbikj6xkw57y7d5f6z9dwpy48bq8w2s35q";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1hkv39bn0f1h71xphwa1dikwsvxkcvpjfdrrp7bcjrafl7nal0wh";
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
