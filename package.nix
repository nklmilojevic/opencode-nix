{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.1";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0gwjc4rd3rlhyqy547ki8pnw9i6dc40qwqa9v7axbafqv82l6032";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1bla66az730h84pwq4v8s7srpjj7ac74w1mid3dba88gbqfx6wcc";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0163v3c3bqd7dyrczjy8xwxnsz6q2dx7mijwhg0l6piqz0j8a4ss";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1wcj58fvr2gikxqbh4b46y2dqqqmrdkk7c2y6fiiamaklaf2l4qb";
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
