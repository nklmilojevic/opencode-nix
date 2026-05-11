{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.48";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1ki7afcv57wghglfywxqln9h6wy79ix4iyp07vvjzxnmd1sskvmp";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1nsvhlg20mnk3yk86wp26jjrpb8c63jg9crda4dlkdiijxq464vr";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "11w4c67sj5r1fk5i01ldjnj4grpjg9afjxpkjzkyzz3fhcg75053";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0f39p5b6w76ba6b3grfv50kn0jhb0liznwmiw73nw0fbzryqdp29";
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
