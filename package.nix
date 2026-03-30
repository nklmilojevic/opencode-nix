{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.7";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0dgb8aamc9xb9afbrphrf33kfkfvgx2nymfbyfa5cypwpcx37ip2";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0xq4xmzdhsdvf6ffp35jp0c6z66xn9ajahljfd7fdyqdmbn80625";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1szz05av4m6rdjv97fdm7d94npwv1gs146x4y4qprzzibjc420pi";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1b13avmfvda3mkz16ysdz1lh756qjadsp5694ymgcn7cqs9fs7h9";
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
