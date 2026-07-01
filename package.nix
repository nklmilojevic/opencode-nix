{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.13";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0ca3x2s12x3iq74h9fjsih3nl5liqg4lsjvg3wjy2j9l9ks75884";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1d71gilpyi0smrz04hrc85sfmmf36csgay7c2sn2kzvjw2s0vk6a";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1v7m6hy988h2lvdwijck0zvl67gzyicw6h6b541p8h83pi5qlgbb";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0gvyf4qx9yip5m2np0f508h071al3bqxvig1za1m0rryncpm1apy";
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
