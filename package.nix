{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.2";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "11pmr8ab64xap2b0wl2fkcvxr6kgs73dwcmsmkwh3ram5nbccgr3";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1j3cgb8b5i5m5wgd4k3yws0g55d3w61c1x3z9ykfz9wi3znz9rf2";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "08ss99hi7pf8xjjahd7zbb38dpp6c01k9laqkf9fvnjnzyqrdjs2";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1rs9f9a457fd8mmwhllfar741q3h8jsaypj0w2ydgmil0d96cdfb";
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
