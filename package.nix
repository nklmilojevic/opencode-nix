{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.38";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1d7a7z5c8kiafdc5avkybqcckrffaq8gj3iwpciwfyym3w3yvhhx";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "033r0vpvba8k7w01agqr19m4pd246xwj4k2djkxx8b430fji51zw";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1hfh4k4kzvy701062hzypc14yrlpbzywnvli0xhj57z13q9850ly";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0vqck464a8smd6a4a6ab3z3a6c2j3bcjrnhcnlp2ixpnlb0xkhbg";
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
