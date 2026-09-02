{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.27";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1i1s6v9xnzxz0hq2xwrvfi2d71iyrmjkbv2ls5xyaljg82x8dfha";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1s47h89wlc5zls5pygjgjsbdpafvn37agh65cfjb6wddxh93igw3";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1wp8fxa53wx83ppbkin5z3d97q30yyw5790lpfkda4grq9kr8dwf";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "100nf0d93c593i8dnn9v54ghcdldpfav7m7m01y1nj98470l5afv";
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
