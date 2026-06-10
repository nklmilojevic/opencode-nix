{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.3";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0smb9l25h532i6c8xhhyb8s27mnh6allr229j04nm12r5j4k6shw";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1w31kjylq55g27jyrzjdfs30imsg2pwxqgdchham4r9dklmgzlqm";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "05qkksnxraysw9mm0dzl8x2sk6w05a74ajq7k9vfc3wih749v9qn";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1jhjl921i26pznrq5sdib9ccrcx34l8kvbyv37c1i2az4bqifcvp";
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
