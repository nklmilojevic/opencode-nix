{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.34";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "06agp9f5v6rqba10iiqpk36jp8yglb9kk95nskm0abbmdp38lgmq";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "04fklfbr03wsr78x6wa954lfkmszvffmar8n5w0p5gr61f1jn8bg";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "02msmhb84szy5jjk94bx015xwxhkfdpizdf5nnr6djlp6rb5r8xx";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "01dzsxlfk9fx26giishdn35jmfvsr079kldmci1zbj44xs8n2cws";
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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
