{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.31";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0041q7jx2xw818rh9fxmy0x0yry7d85klahrk50mdli4h0dn2p3p";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0l0khh4gm3y0hl3plhh6jynpmk9ykr0ghb73fi38anhi98snsllw";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "066vz61pzqzj1clvplvynw895dxl2apc90ng1fpd8jd9062zdcpb";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "175kpxlh8cn96hi1nyj32c4wcdzxbaa149nyw3x22q3im3ppxfkj";
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
