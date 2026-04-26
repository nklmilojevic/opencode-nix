{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.26";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1l9ssxnqx0yq264d9vbi1wwgs521jnzg29w4fdxbrmj7dkwn2pcg";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1aq1awwf657hgjrvy6bg62bk0z4b1515bmacs41akrgklh8ssmhf";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "01sgfcd3dx69l72kk8slfij03r60zhmyq9bblypz70rk1nyjjax4";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0li5x2n0f740finffxvv5mlj8v75ayv2x6bgpvjhq5al63r5jzvs";
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
