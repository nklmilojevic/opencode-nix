{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.17";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "034dfy6fqnybi7lnzzqfa8nqkij88yj3a4n115ln7l3x9hwdin2k";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1wbpzk4bygyjqjbp8yjcyj2m5lvmn0qys12gfkls297wlrx38bp8";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "01hrbkifcavmimmpsj5hbbps1n15lmdya1fi3lim5wlc199dviax";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "08gn7sgham8rkj5cwirhdh5fk0npjxi6kzicabwi1h6n29y7qz8c";
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
