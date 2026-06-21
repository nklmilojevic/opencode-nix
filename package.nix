{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.9";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1mqwxsj06k6nrmmj578i388kd8sjs0k3jp3z3z2mm5hpqhkq7bfg";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0k7k30zb2k978ragh003mh6x3j6y7vhqxf27h984h9dq3qdmgmqf";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0lrcmis3cdywfjaqzip634pnynwhf4db8r6r4d94yhjxvv970cwy";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1bf9glv7g7jjxj9119wgyr4k1r55sbjn2yzhj38a9wg34ykp7p96";
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
