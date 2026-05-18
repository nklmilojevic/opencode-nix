{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.5";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1i6brpmasvac7igili8spgwxwf88ww4n8dslx67c2fprx4g699mm";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0pzrdbrymh5al4cv69a5q76jf8zb62n3imff5zii2sdy48c5as1v";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0imzmc2h9w2b3n790nf05aywpgg6na5jmcv5xy924s5xvh377b7q";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0wx9bzkf8xfss0xb18pig9b2d723kji0m656sd1a3cxds6749v87";
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
