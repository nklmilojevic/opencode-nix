{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.50";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0x4gi1cd57c1sk5bn6rfx3dwh9rsk4cp3nkpnf2vl460y7gh8v48";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1xnbn5p0kakz1r6jb88cs4jdrggl27736pplvfd7fyrkdck0018d";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "054b7xqnlkq58bw59jnsb2j0w61frx2ys0ssagci8wwbi2yzr221";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1inwymh8ipqw9a5nwmyc09isiklhhmkzx4v3061qfycs1mwpvimv";
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
