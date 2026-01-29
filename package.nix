{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.42";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "15k58hzfbrgs016swnp1h7ibc9jzi5l6msanjins4sfkm20sf3mi";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1120mh6ckrjz0hqy7v1c7fhs4mgi2zi2kgl1r9h1y5qi4dzbdj23";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0ipwspzd7ckg65420mcqracib3k0k5fh863fmq9ql437y7yc8w6i";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "03v3b8cl6yfjafvn5kdw80ia2rxm7i8n1gry1xik3p9mg4xff95n";
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
