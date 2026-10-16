{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.19.2";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "118i4fp3pvxdylkyzwmv06hxh90w27ibmf3hysyj4v8xcis1v66i";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "09554xkmd9h7jvwxgj8bf21yixgsqs19ki4y2ynlpcnjlax64lvw";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0ykffrcivp60k0vgg1zry3b1kwcpp2vwvxdbz2mnjfvn1dlgi658";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1l71s23r5mjqxk4w636i40jhr5384q714gd0h360622cmgl41sp8";
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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
