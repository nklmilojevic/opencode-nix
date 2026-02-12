{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.61";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0vdsvdajdhpzk312k6gl1z1mgxgxnq8dg92mzmidmpld87p0dbl7";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0ic7qq6z0i29s6xy4j3dbl2lc581sd7d6vn6l0rcbfybp292wr1d";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "10b5nyafg12xsfprhibibvkrh6img4lzhy25gfx9adz7zdgvv67m";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0rf8z8zqcvdxqdsbmdhk8952n4h7hnvyawfjysrz02zf2q2b6llh";
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
