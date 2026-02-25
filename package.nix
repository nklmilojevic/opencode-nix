{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.11";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "17isgjmb2cxjadqdmxbr4vbinjijr24khnsjprpp5q1n74bpix8n";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1rbjslqxrx2dzqfpbpdx929h2ghbdbkka646rx6l1nnr9kslnlsx";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0vay0m4jg9z1k1hhhq0siyl1hmlxy5s2b9b5ajwm53ssmm8r1sg0";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0hsa2ik81dfrywn6hdl600fpinppbxj6qasy3wmv2rdsd84wrwm2";
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
