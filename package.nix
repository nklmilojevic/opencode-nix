{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.1";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0m11s604f3l1snrz1qc1yhw3cz4zh9rjpil5yrvgjgcyj97agac4";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "19m4222979xgp3b5wyp053vf4p1cdwdr6rnwq6r17qz24z9qq788";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0xd2k6widrrhx8xkjchlllzrn0l1sc53haxn0m6r89xh8n1jnjvy";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1gip3xxk0gnw96nm0kcxvw7bjxnnpinanywdrk8zrafyq9x3rr8b";
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
