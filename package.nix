{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.6";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "176ssj5n5s52px4bhsc4dirf96x10764mwvclgh8akkc2q2p6gdw";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "07r9kyc8ygc5bmsha4hbb7a5g7sfxf05zf6p5mbf2g1j9qclh6kj";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0dgwsvjbhfhgc60rkjfbdpwa3qvx4lg8kvzkm9lbqsxkqpb666nr";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "046yzcmvwcq19rc38cvk4fxdy1icm0r4xq9228l4ncaal8jjqrpg";
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
