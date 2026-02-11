{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.57";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0m3fd06dpfxi2wlgdiyn3dm4pla162634m82k9gfv72mbxvj9mqd";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "15pkn0piqf6613yh0sqs53jhpq0y698wskccrckcrqysjlfzsybd";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1lcywlmzwwmf5znf4pzr2w64r4kh20w95vz0vv2mfqyp9ay4shqq";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1ai86spi71v7fg4a6dd3rdjsz75qc1h25y09acl49f5374whg11x";
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
