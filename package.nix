{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.10";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "11g9a59m4plvrgm18yr0vj04b6dsp9sb844yiz1vmvp4qsn1j42b";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0hxq0gy0dw88vz0hv9jq6721hrz5gbdv140mljzlf2hpnwbgdzw2";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "097m93i8p9fycns4cx6mvxb4miwq9cwyz4plc6xkzzslils357z1";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0b09wbv2zwfbkcgy2z9q4r8grhpbr55w4b1bzfmvfpy11qi0y9gv";
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
