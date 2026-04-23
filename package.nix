{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.21";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0q3pq7yalv15mnl8k17kg1z94739v3iaygx4i5qd6vwv3awh1a6d";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1xqxn19m2dzpmdgda6vqpg5c2w95m19flx46ixgcapsb601194bm";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1bz32ng24sadll451p8zh45z41hmay1sdpsrf3c3hrx16fsbpp34";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1q96ijdh16m7l3nnwvpw3klbr1sm1jmsikxxbir2izd1y9yxll6q";
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
