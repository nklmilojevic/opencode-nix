{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.9";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0x5fjrgjv0n2aqmxj7yc6yscvvb9vgd4sfag91dqxnb8lgj07af3";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1f1290287cs2qx1wsp4db4bkp081fn8mnkwgvymwzgjdr4is87wq";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1fwar9hz6vv79py5bagjn4k1p33pl6s5iix5hwfvkh2crsnbz5vi";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0356ffbrjw72zjm10zcm83zfkx12ck8g8afzm8mdjgznpij2kxwf";
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
