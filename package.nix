{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.5";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0afr22my3abpd2rd8m0qgm717fqgvvn8c2xywhdny59f5krchx55";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1apd9ib4jvnk4dhk43fq6nwfv7f0spqm3gm70jsl5cmxblv07bfy";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0vq94sbq2iljrg6b06k8xnqx099pwys6dj5qna03q77pclcnc8j3";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "121vkbghmfxfdnlsvs3f3a0nqinyi26aqam7y8gvaql6pp0pagkq";
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
