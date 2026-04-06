{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.16";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1ikfcl9ff8fw01nrbcfyijxn17j25gh15p08v88z2wiqqm73djq6";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1lcjvnr4vlfm4fwx45mbl352jjinp6rai1g3k0iz1b4b05hb6pkx";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "19v260jvc49j5a7xjijbbassciz37wjzpy20prclfhs82vpmk1kp";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1gp85j60y3byjjskilcsf8wxpj53nixyc3q7s9gf0kd5fgv586vb";
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
