{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.30";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1g5w4sfn2b0g11njmpx7qfxflv86s6h1wfmbw9y5s8y6k5yclibz";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "05rjgzd9srqk2md0b3d8v1gp7g37vdi61b4a86vvvjwbcsn448k8";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1yx2j5mjgfwpzyc18dhx3gl93y9k98mmjp02mb48zh2cbxnfh497";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "011acdbd5qkqj5zdmzdzrg2wnkfqmj6yh2h1hlvb5bi35fqxb9yz";
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
