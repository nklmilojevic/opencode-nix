{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.18";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0d49kwxr8rwh684bfrjr3k0h8csffp4xxsmfz0qfpddbka90rimw";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1q87chvqs2fz2vr4g8g1qpjl5z9cbc4a9biwx1rbxafn6bkq75sz";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1cndqlg79ik8x16y7kw990dj3h417nkfggmny4g49y7jjmjxz4i1";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0788yl6npc1l9h3fgm3f7aiwv7j8cdfc8j8db4m0xyi8hwnkxd3g";
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
