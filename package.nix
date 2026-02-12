{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.60";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0w8v7zk17fclbrnnvbcb98h0wpsd5qgbgiqq2n37br4swff9s2bk";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "01m9ih7kyj5i5s1xl36va6xriqk0smfcsgw8cz5iqdv8iw806rjy";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1xl7ldr79pjb2ggz9d4sy2ii362hvajhf8389b78l75inmjw9ibx";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0hqqlrlsn1m9nagvq7qwrh0wbjwsj0zs8f685r4s2zpk95nl43jr";
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
