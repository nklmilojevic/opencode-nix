{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.40";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0395q4ibk62yq5k6ib741gd3p447prdsa65qwpl8yf2pc0bmnvld";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0s9ljyjl5przxgvkf8i6j7lkmp6cjj5yyh2qca97pj5wsv78pqab";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0a6bxpsvikhhc9li6vq8viwp16nljrxjdsmhm0c73123766scr6v";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "17wsgja8cxlz41jhfsmzw5i9kpqzj4m6clf1vnmbqm8z1pbjjpmd";
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
