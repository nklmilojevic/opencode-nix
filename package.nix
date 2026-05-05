{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.34";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "16mnchf50lcr832dkssqk2zbkf6wiz7amjn96nlnfrd4abz1xz3k";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0wyx3qjqmdhfr497b87qccsxjr8rbk04wc3h93xjr2nka2yfvwrm";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "06r7kak08c0aw3afs37sxb9vq087xl399bgw251n97zk1ipz78id";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0gglsyx80w6yjlgc8xciakck30npbpnd41pzba3l6vnjn5b4ph41";
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
