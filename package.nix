{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.19";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "040m37bf3c12gnkj0076dm7d9fsb330kpi7d8r885h4lvisxa1f1";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1xfnnda5gm9inymxl77v9ind1ls1vfpksz9mjbmz06fgwvdx2nsr";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1nw57zvl9xzi8qjw3dcf8psf9vyjg0f0zsbrz0a96yv8y696bv5i";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0355g01jq65pnwc59d00z5zhf0iyl99z8ybvc79xnpysax7zq5gp";
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
