{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.14";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "11r1xf28a5xvxxpqdyd67qbxq702mgbf306zmznnda4y9ix2gjf9";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1fdcpsha9xg786k9gh926ngalbw6rr4ph0drd5svy5mk3qib8amw";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1dn5glrjlx2x48h4k5avjydq8bx0f2ba20kcdq458mc90yrs0f3f";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0qd73wq54lcsk5pksra5f7wyw5ayayxcm52n5r8xk4h876axg0j0";
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
