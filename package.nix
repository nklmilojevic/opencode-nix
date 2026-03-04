{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.17";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1azvb3rph2p0w8szhfsg5dng5qrq38qlsppr5hcqanhzfhyqmcbi";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0pfcjf1xxkpr2fdhv3hrdm6mswgfpprxzq8qczg73inj198zbk4c";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "15z7npmkrw4di13ymd2pr9pzc9gfjkh51sjpvx68747rs14882i9";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "02dwyzs81cblc72m63ms9qza1446fp4xb8xvimcwhijsm9g8yppq";
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
