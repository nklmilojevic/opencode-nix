{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.19.3";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1insi10sv2z8n84i8c9blwrnbkgdsnqhcs5rivzsfy20xc9pbmki";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1g3hzb97px5x2wd4v4aanc90bjflh9hlqx22qw0rp1bdc5f275rc";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "12474l749ffm76dr2lniz56rcw3j2rczr545j1jc1d7lq02xf9fc";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0ckv32r013lx2k578nhchyp992rfaq9di5igf1qzk78gy3qkq3bb";
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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
