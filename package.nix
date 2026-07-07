{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.15";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1vg5c24wzf5af68vny6l0p4pfbbrnwxx529zc2j7jvfqqkfkw7b9";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0pgy4zs2bsvjpvnf295lsan97zjxndwfllxdpn1w75z30g2cynla";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0p4hxj1ipdr92yqsf0aldkbvw7zdn82j7m9nxyrndl8cn2g6agrh";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0vx7v31w653xrhqin2nwwxgs649zsqnfcy5vipcmf7dhpnmdk2s7";
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
