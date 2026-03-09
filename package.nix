{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.23";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0srhsknqz1iazkbv9kvnpqqsikws4jgj3hj6v4rwcd77cl3bka63";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "09mfjxqvzfzipb69alb7fdqjh2i8z765i30gw2i35dfryd214wa0";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0z78kd3n7dqy84z5q1avf80qkzwggxkgf389jj7pz58gfr29ln67";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "11hglpcxfmp584d0q83asz5byn4arm4g06njrs9pj6p7570z8sg4";
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
