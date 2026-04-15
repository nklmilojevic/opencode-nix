{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.6";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1mxm4dyw28wbsqiahj65sx439xxl95348jhpaq9lhwrl21323mjf";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "182h7bic3gngbkjbgc7ajnd23y1c46kvc174wh226ygv1gcbc2h5";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1a5pvrh5n5fy3c168i6anv9blk8hkdys3g7x7jbgd8c5npv4yaxz";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "07rwcw4lid3afxsr5068nfcqypsdbv1hflb63s44bk72ixy6fci8";
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
