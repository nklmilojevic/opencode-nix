{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.50";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1csky085vzbdjhq8hwkqka0rak9fanlhs0r5q3ydbadq7c19lfam";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0lwki2amwcy3iwhwm98xfghqzdvcpkd1v2xm3d8pjk681bw91qj2";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "08m1zgi9lb746k2xd8npjgambfckidaqadsjgfn7r4vqmlmnx6c3";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "06ama9i21q5ss0217s83hkpinncsnmkzg24vv1hfmy9279mjs0mj";
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
