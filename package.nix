{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.44";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "07jp76pm7ygkc4vdcdc3fc5y1dkp39i91q16fi3cqwyrpqldc14g";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0irdjq8p1d0xqk4lcisr14q28fg9l17hgpxwzhamrmc6p287jdkq";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "17gdjh35p0zr23dxa7axhcwij6hgrdif351nsvfgzzzcwjgbpmkx";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "03hx3p2jdpcsya9jq46ifzj5dzq71zvzf4gh5q0bb9496jyx2jzi";
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
