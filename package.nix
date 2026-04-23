{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.22";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "11vl2g949sa109y955hxm908d0lxss0i6k1mkjrr9a6bs1cc4kp3";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "05dgrix7xs8pcvl1y8qz97k0arpl0f4x0a1a0g0zclxn56i3llya";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1ynmfnc0wcasvn3362xw0h23fd3nlvv34n5dbnmrwvhip11dslzc";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0g3kwcx7m11j2x6s54acvf4p06b0mmm3ych70yzcc2p1aqbl7srw";
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
