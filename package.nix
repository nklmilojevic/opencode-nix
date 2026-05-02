{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.33";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0l6w31rr6v33jjl09bdwci7znjfrk8nnklj06bjqw2sh7jwwb1xc";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0glks1mgwdgm0lw0gry6wyndsm1fa0lqjf34w32p2wxm23225jj5";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1n8y61nqhl02xwwk0x9xm4y82r807x2g01cqcz6ywgq8qswr7s7q";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0r1v5p7iivzmr7xy5nimnka50b7zfbxpfviw9gj6zwlg7q3psk6g";
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
