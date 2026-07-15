{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.2";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1ac44b7v4vpkxdx00f9d5gpv8dnm39h4vx75y1970zp1wzn1wx8n";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0cj4zagw5bn4j0i7grv2xwpz46zzaanj4mzcj1wmpzxr55i20man";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "074w146r8g3synpsr5wdq2ghjbnbgnf9jqzvfpfgjml5rd0k8khi";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "11rjjdmcqjyv62nj77d3g504haaa4p9sjf6iwfzvlnv8hapykhml";
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
