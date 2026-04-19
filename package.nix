{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.18";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1z0w66c7kl2wpd2b70dy78yh9xilk9r6ms8x9ld9bigx1wqcfzgx";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0i1c88nv2rxrjd1h42ckk4wj9zlb6a6x6vnvi5sm6q062s2659lm";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "13xs0rx286y9bqnhgh74cnzlmih3793ygv5qzrrs2ks1hqwpjfxk";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "01zvn48jviszx662nwp81hhgp46q30rkbw2yfvlq9373rsilgf1c";
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
