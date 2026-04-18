{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.14";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1mvmcqbhb4b646ykgvkchpxlvyhigxjax7xi5a5gax1mrp6b94mk";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0nv06fkh3dikmm809cw5sf7rmrlrgcvjxw55pmyh0n769x7k7yak";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "10nk3in9h61da5kd6ysksmw3lb6pjvsvxqghq6j134w3gynbfrpi";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0d1f2w6hxcj86r1q1p5q84v2mb07jf3m535fki1n61brznbcm6m0";
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
