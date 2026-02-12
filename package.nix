{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.63";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "11094iz2c85rfx42i3phdw179551bkcdfx6ba3xq88vjklknq6ih";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1426h3l8gi5nddlqjhkkbxlr4mqg4bx092gdwpfskkwy6al5wgnp";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0wl8inicxvgx672bi8m9n7cbpdw1v95j46vd0cyx2kccdg4g0n1k";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0qbg4rkyi0r9ckksi89l3y52i2nw68dy6lw0lms25qajrb5w5a76";
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
