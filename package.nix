{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.4";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0ymrqdkjaxw21wcvq0cbwgxxpy3h8rmshb8h3ydqvq3ajhk33a6p";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "03zrm3g6gy4cvda8g7f6x86s6m15kqygin86mkmhw50aks02330d";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "13xn0g70g2bz5zc7akg96jak79nlc1077yq1czw3fcd3j60jh23f";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "159zxl5vq31dh1yx9yjxcdwfham431c056pf45l65rxb7qhx0nb4";
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
