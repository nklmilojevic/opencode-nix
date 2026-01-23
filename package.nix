{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.34";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1bnc1df8mz200ndii3cv73lacv33bl8ydx3cmw5lvdn75mww9pxh";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1dwb56zhs2ngrr2lzv7as01mx6x7xx99adrc9ibi5kzhf6sgkab1";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "11k7k6lff5r1mvlhjjka7qd8zf05xjps5g8w05zb6gqa5g275qx3";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1y85njzi22m4qpdsfl2570nisgswc7l9kwsayi1lxjzh4z67dv96";
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
