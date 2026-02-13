{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.64";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0m69igd9fhwky2kn0vkqmjhydkznjb76d6vdnnpj8y0syrr1km6f";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1fqj5si7aryy8dpp9x0v3v28qhwsvdhxaxyyvqlfzhnzkhspqblx";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1m0fmmwld7dnlvjw8fc45p0vz7j2scq8idw20vrg6z5icpdzvryz";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0a3jdnlg5v28a6ix28af0sg3syqwf3za48dzkivkhl2z56w5zhk4";
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
