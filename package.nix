{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.16";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0ipv9ayzjbqvk6lhsvqragz49ha3za62pvzkdxq68dkr3waky624";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "10azl4kisaf96p7564sg9hkr3bwk6qa0yh79p54qqqxf5xjryr9g";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1w44l8fm6zs5ihr4psaj7hm2xrdw59kpfn11jbq3xiyixx6hbvcg";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "019vwjnrk31hdssfwbcl43fgrr8jlrp5w4g5an5g3grqdkdaa0cp";
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
