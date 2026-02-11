{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.58";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0xpk6174bm74pgj2j60khj6vlzd67nz6f9wjqq0q87i9hab77ah3";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1y1bn54llyxmfkgjra94g8139v8y66ycn36cvz6aixx81a9pv5r4";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1w6rd2xzl87a994cznk1d8gqqmrfwz0ir8ywh36ri8v08ayp9i6w";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0lnkf5hgvhqsw0rhwdkrl33v3la422mjnn1j911f36pfpppfvfsr";
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
