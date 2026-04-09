{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.2";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0zcfpp9kbfqh04lifldnwhcnm56jn0iczfzw5a0i8lm731g9ckxs";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0gc50idqdygif387hibcgjbja8bda373xh7hlks5m1g4wgd135lp";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "18rskj06blhcql9yr8mhrby1x7ld26vnklinfxjbd18fxf1hwicb";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0kwahsm5qi3hfcmra7dmwxsq91lz75ig5y8fp3wyvrcd7w20wf1m";
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
