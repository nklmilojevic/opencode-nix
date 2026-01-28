{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.38";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "12bzk87iifm6r5grxsly9r19nagb0jrlki2bsk3fv6aclzgz552y";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0nbp4466all7dnk5affq340nfhffziclc5i2x8jrhqdxm3xh3c99";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1mqzg051yb57pcf26b5ivhm64dm99y8bdy0bfnv794d4n3s0d4y3";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "15ml5dx3z1v6sxssi9ygy2v5kpzbwzflwkqddj29qb2l3drwsgmj";
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
