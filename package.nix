{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.9";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "022kx62a13adk5dgsawxjxbymlzvv7rf57qm7dkkxcpw3wz3gq1y";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0xfi97w49kxaqyl7is8fi58izv68kscyaji1d830qkm2p2rghvh3";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "02f7dw5b247b4r5gzk9kfg828blqi671rnaim07wbxqc4gqgyvpa";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0xd228aglf08pzf77566gydya60n8gdlfjfw8a92ym7457dalvg4";
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
