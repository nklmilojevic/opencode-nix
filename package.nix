{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.21";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0mr9q4zywqwx0bnm67zysyqwkpbnbp0d4hjf16q004bgw96zzncj";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0clahc4sv84g1993byg7za8vwz76q37f9v40vzpp6qfs7551wfs4";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "11k816frml44p1s9s26hw624idc0qcfkqs8jprxxbp2ms3p62xk3";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0px8vfs3h7n81m8cxlgk8zbmhkz3k6pn50js9m47szd6w2r9p7yj";
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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
