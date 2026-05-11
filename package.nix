{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.47";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0m64p5v31fasx9zffjaf7z160bzjbzdr1nyrcx9mnvlfh21g7f5x";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "02w313s6yxv02clp28p9davxprxxjm95bz3sxzw16clxfgrhp7qx";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1rf8mdwzg31z2x0d9s2r709nk8rfssk0wd6wkms09vdy9jq7d5dy";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "175w7f1nqzpwpzb1djp9b10cdw605514wgw5cmkdkkf0c6h81fj3";
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
