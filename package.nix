{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.15";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0w8v7z594pf5llfhlas80xd6dnsyws6fd9g29rn8i6sq0p5nslpn";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1ypy6mil6wm1yl8i5x9spzcwm67w3xasg3mglswnxb5gs4b1r6b5";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0vasamplpjkgi0c2x8g1155p020rx8kzwgyryxw25jbsj3192vmc";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0r8r41n8n1vgafqwks3wmjwcd54zyb8m6jvx1kk4wb4ddkfgd2yh";
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
