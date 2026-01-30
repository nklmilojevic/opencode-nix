{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.43";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0248pgdja23l1a7wdsf7x7cfgjnj9ymhaygbsipa4bg2m1fpkfy5";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "187y4qsp7x7rs84ywbmm9ns44kha26n2zclyh82g69i44pwb29hy";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0snrylvk3rajp73ff7q091v588x3nh0vflb99369jbbv99qyyn13";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "18cj8y0ggpqjl9mrcbzzypppxzr7vzsl0sfwg6w4i6z0q2bd8iyc";
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
