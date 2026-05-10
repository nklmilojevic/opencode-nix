{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.45";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "19b8zwqzfnbdfi00nsnbayhmz4m98nxmq44p02qgg8p70aik5awx";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0ck6q0fzzkz34fjsf8w6k3m4ik88jmqd5fvdnj21b1z8qp798m5v";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "19gl01xqa57b3bv5jwwmb6sy05n571ha2w5vp9zdwz4592rris6n";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1zxldcgk77rw9g0vmqsl9vkf2b2wynzfkyzsnyazav2gs1kl33b6";
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
