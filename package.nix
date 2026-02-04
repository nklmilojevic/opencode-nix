{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.51";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "16mbh9l7x187iy76k0hzah91h4gr1ybjmy4x36lmgp3vmgwpmip8";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1ccpk5bqrlnr13mc39j46drvd8c7w7a01fx9nf5a5533kxaipqkk";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "14iw61f5pc7p52kvywm7c3ifqhj2006zn6w6dxfvdr7xxy43l37j";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0mjsmnzs3f8brjmab4d7093sgk5g2qyjnm0h9gpjql7h4dhla4gn";
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
