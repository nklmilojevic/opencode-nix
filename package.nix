{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.13";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0b2b2kmvf1hc6pbq8h0n6l1i058mrw5whfcmrsfalfyrqh7n511v";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1b464vgp9ikwafm0ia4npblzcn3a5140rkwqxzdnkcrg0rnkvhvx";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0dyah8h7lc28h9yy70gbbixpxazbcz5fm34r962j270bm1v8mc39";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "06shj8plkrzkxajhzvk9wqq6ixl7cn80gkclpnpayr7wwwn6lm70";
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
