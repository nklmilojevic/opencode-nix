{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.11";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1bxv8gv5bna1cbsklk868qbi1r1kmqv8gb3609v8aldvl6l6dnxi";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "12ff8n84fdbhg0mjh1fbcfqqcv2fc5djgaf0wcfcwv8i9g30h030";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0bldbgggmq1f2yqg49q7chpcbbky3g0w98wxdmpyqnmbk5f4q17n";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0i23yvzmsqf7yixc9ykyl07qywl66kl2x09ljgqxin0kgp8idyqw";
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
