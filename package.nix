{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.20";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "15lykdlqh3b82hzb7yf75sayz5h21zp3rndjn0rv7xjr4frxl61d";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1gmv6zbckx1cj83v92pymiw7j95zj88gwnv37xbgla91yq5dq6kk";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1vqvf77spmb2fd5lk7rxnkw30ylsz5c1k8pv05802rhv7581mrhj";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1vp6gj1a23x33ssg6izfvg5m7p0ri8gmwv6l9yl7pyk9pdqdnv4p";
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
