{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.18";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "02csiw0gcr5a0pp7fj330nwa7njnywqkflibap259j5ijp4bm2hj";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0crq3qppvxj6cny5fsds449p69qs1v7kwn0x3x6ypm05f0ih6z3p";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0n0bgsqmhh6vcslxljbrxr2n5rnjda2hr9c523s85sz4xrdck81n";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1xdkla50h5ghx674afjy0pqc80vfm3393id2yj7shg1lhg4lfcna";
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
