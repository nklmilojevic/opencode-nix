{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.9";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0x42spka4n177kwifmn1mk66lw09lnb27rp868z62a7nx1lwicmk";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "19jkzs5y12d0dpm2mxxqn18m7smb8cara42n1a7g09iqdyxmb19x";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "08hjh4kjr84fmv6jldgzmawq75j2baga1bkjk28mmin27lxsl6xd";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1a303nixrd79wpsah26d1zddip0n39cdf6vnjgfgh33gbyr60cfb";
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
