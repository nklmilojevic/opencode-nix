{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.2";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "07w13ygylhf64hk8732w61c6g39vav432nnmzv6nxvfnh0c2b0c8";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0c7lf2nkkg7jw5y322csz8xyiaj8jypr3x9wgmsfmks51zddhnwg";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "17xbcffpm23cns7jg577sjrvkzzhf9nkfqqdkq69255kl9dnb334";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0li8ygbk3h4055qvxyrvr6ziwgma95wc39iblb8m96mqg8l7y0s7";
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
