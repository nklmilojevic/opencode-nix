{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.8";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1np6mh6dddlh3h7d3hbi33b2s8y5d25k913a8z7c5fs4mind8i1a";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "03fw88sw12s9q31g95b3fnw6n6hmrdkzhx56si994hvi65r68w25";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "05sz2dpspn8cw40y4qkmgg39vpd8bjvp8v8sxx9fd6xmgcsrykl7";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "156zp2q565kzcmh5kizi433g1iam4x2dzcklzjj6952fvn8gx5qv";
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
