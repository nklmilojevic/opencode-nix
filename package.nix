{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.10";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0p6832s95gp2hd6y3viixksxgv2jqx07a809bj9z0m1yd1njjj4s";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0sqazls4ql8i5miblq57s53b60m9k9jpcw6s5ymxw8jnn5rzsm60";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0yk31yyjsylywv248ia5wwdw226q5jcz5vzqak41nmavpca2c928";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "13piz4g6byw144lsai3l9bxbr58vi3vl7sg6px99lnxkbcd82dw8";
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
