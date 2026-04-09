{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.1";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1clcj7da4yyzrzh8ib1fl6b3hhhyvrhlj05i3ij30222jdmn1z4n";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0wasxabj88w680bmgqhhvhy169rxzvpsjmmwbyrcrxxaawfm53zs";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1cwyk8fhmnx85v8brljqzjmbfzhmvb5blffkafyfajp76w2kl076";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1iiyn7i3z3sc3ad8pwyqaf37l7kssm42p6n5cdlzzbjb6ymii9zk";
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
