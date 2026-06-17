{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.8";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0476pyfqzchf0mriyi582yd0aayygz3ii4yg3hv5m4i9vrywd7k1";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0vv4n5h1dqs90jamk65bywd8jnpw2d6z836i6kgs2kqc5ndcicwl";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "09zdz9yg0vazbjbfm7crsb6dwam4i1lfrag2d7s0yy1yk9skc9r4";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1mqar8ijmgk6g7hn0v4778wvzs46pillgrpn43mx08dqfp593ncz";
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
