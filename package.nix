{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.0";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1qf49vxb145fy3dgxc40k259vd8bfagf0v8gx2q3sy7lbrfwd7kv";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0lpbc08v7cwwiid2mshcgw6l411s1ry53lazif4j7s53x9k8p3z4";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1cvxqzmksggxmyb04n22cdqm73l4i0jf0jsiqyl53qfklcwzm64d";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "180cpzwzjv9jpb25k3qk2ca8bs63xbbdbmfw1rlhc8x0gi7ypxin";
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
