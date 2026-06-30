{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.12";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0a9dswg25y3mkccb853r9xfpx7md3f0fn5z7jgnvdhh3ip26jlxr";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1z8s57n08mjxbwjcn6k9ddwnvpfwv9a6fs8jx8jf8x5iq8q7aqik";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1hvqls22hcil7f4m6ald766bxysv1sblfavf2drrrg6r5q1cg9si";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1qvqk6558jvp91m823vs23f5whhm36x5c2l777igfn6ssdf2wikn";
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
