{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.27";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0jgjhf9rgki7qrfc96xrdv4inpvzclxvjrqids7x88srfjbwr804";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0fv87b51sq6730wycslygqivlc062i4vwxszmfvgxgs3dz5p2qy9";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "19m7iwfv9f31in44lsnp9jj0l6s5d6c4f5a51181l62vzca8gqx5";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1n3rwcwn221gvjbxhqjb3s8m21w0x37pkdm7xw0dnj9scw8iwfzm";
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
