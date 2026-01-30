{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.45";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0chd60fafmj641dhp839sdid8s7j8yvvc5f5z0y4qfc76xpx6gva";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1b4yq05mldzzhiv309d8vi5wr327ypq879dik6cq6ch1mgr7n9g8";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1wb0m3f5ppx4rspvr272gz079c4g88xhlik297i8cmf0ag951k8m";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1dk8if7lr76gd7l35g28ghs1a8s6vw8l16l12ib5m6l3d3ygkdq1";
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
