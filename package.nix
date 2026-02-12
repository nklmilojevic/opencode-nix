{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.62";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "041syx42aaf539h7mn3843df8d58r6vxxvh0p4rkm3rdjlzwwym0";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "15y6qxfp230z8shq0ws8zqfng3dpx7snqz2jri2xli0z4vfsffck";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1yq1wp8gawx6k84wsk89gf0d6j4q7bv3yd8qcjky5k71g0xk8m27";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "04xmzizw3zddlbqzcbv04pqk3icc30mf2fnnx97q86ra9sbikrgv";
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
