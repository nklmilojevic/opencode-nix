{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.7";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0kya6ywbamwlyh6sxkgwz4659gihw0wsl809a9qws7f6710cprc4";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0n6riih5n7d9796c789avmqnl6xv4l7vp1lhqjcakzj85813vbzf";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1blmh5ahfmyp8yksva0hq11yn07pb03x4fzvbkb4swjx2npqbj62";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1lcpgamn28a3sh6zds97h4z705dp6w745zdwngqpdn9v9qrz9h4w";
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
