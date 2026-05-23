{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.10";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0f7n2avwjc54b4lbd9fwqgx9nbjs1v4xa8bnhq4qfk17jf5njcc3";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "12gj5wda5vgn7386k4x0wm0nimzyxb4zw5iqmkm233nyxv779f9h";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "11licm7ybg7cs36wrcakzp5xxihh78cz8z55c6g4znwivvrfpidf";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "19k2m3p3s2sca0ykm2bjq8xsvnkx015zahj3qrkzh9g6lsywcmgq";
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
