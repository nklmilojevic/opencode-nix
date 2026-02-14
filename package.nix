{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.0";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0kwhr6zinf8ihmd5rng2y9g98r80xcvi1spm1knnxyjbdin3066m";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0n3z155ny7706f06b5jjbjbxrhfxa72djlr2axpa2mg65qnya4yp";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0p69ckhi67cb2ar10gzyc9cxhpmq3arbg0fqffni038xmq0x89ha";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0pp8cf8d28li3knm671ymfkfwkamnm67yzz78k9bkqk8j015wash";
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
