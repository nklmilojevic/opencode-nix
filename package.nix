{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.56";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1gdb6fnf6hnd9z33h3qci8dxvj4jgv0j67kvcfyrcziiggya24h2";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0dq5ziqc9iyg0d1c9b3vhg35i3cgizfcqywix96q021060ngigfv";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0rqldg4g4w46pik352akd2x2cllv52mdr91vvh764dr7cnwnppim";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1nqg92gfd9ivw6vsz8ck148bf0s99s518likpg4m6f1vn83bzik5";
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
