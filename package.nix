{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.41";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0ccqm2zfhzms7pvafs1nff8993zyqbxy70dcx73j3jm35aj3ahia";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0lmg4ywplkl82gk75gf9mix90nzc0crjl91wjiyls2i6aqi4g838";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0wp2ld8flxi9dwcrdbq6xfgg7bjpnzah0c8x6ijxj1r2aba3g5kb";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "15zdpk8r4h9bqfxgx648pw1fza723kgqviq18nrw4dkarda1w1nz";
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
