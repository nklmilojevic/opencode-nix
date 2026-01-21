{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.28";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1v0j2jdvaydd0dw4lia213knaxy3m7vppyc97xvlxvgc6b90s4wg";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0ck174hml17rlfw4vybgwp2cqrd748s40rv22fgs8c81ri82y2ip";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1x8j759wsyfbargx6d76vg0wkyiigkcihnsg01f33i7k38ns829l";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1md80078f1lfi00slb886lism0i79gc47q5gmr6n84xgns15psp0";
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
