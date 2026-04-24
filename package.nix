{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.23";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0w3n5mzqjcg5141ix8dhm5wks58nn1niyjqkw45z7smcwmi2cfzk";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0bxckcv5gkr9q7m1rsnnxnlqyii9g2wvdvhamh2q1216vvafyzfb";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0z7j0mqzq2snp4iwjnpjcqmc2hkf5pbv839abn0xafsgwybjr3iw";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1ylg7xbhcz4nswdf01amnn8iahl67krnrb2gjpnr9dn7z8isbsjq";
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
