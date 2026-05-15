{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.0";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1n9gzx297s398ay1ij3k36gjayks7cm29lb84vw9rrdz2wb9bf2y";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0axphw2x0yzv5690m8xf89vpy6aa1a9rlqlynswwq8q9ibyy723v";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0afmy1fnw20qsrll1bxd0fwira5ar17033q6v53h4wxizfrm5ks5";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1cikw6nag0qv4fd5aa4awd0ksdazs3hyy3b9pv10ci30yvyacidy";
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
