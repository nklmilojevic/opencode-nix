{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.41";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "02h6nb3swwvislgggsly96s08qljaa28xyb8dnq8nlr881m782xl";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1ap8j9mb8kq2gqlkp1qy8hljm0kx74m7bbmb2g1imqg4js2swhn8";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0c0wc3k8l55sqhkd2a3zh3rckx7pvk124jd6p0hibbb4x98d5733";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0i7kyn4cws6xaysvs2mb14019ngdmkfmmx6awk66w64daszy1b4h";
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
