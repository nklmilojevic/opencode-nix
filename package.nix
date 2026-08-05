{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.14";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "15744b9rg40aa4m8djb3s7h4nw7s3na9v869mkcgi1k1b27hnl51";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1aivm3zicx55k8nfz4fri42wa5486bbq538b07xravldfyggi2y8";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "01yq70i452znngk90mf0728vvjqn48ln8q9n1yxwx2n49dqqklfh";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1xdsqbmg5661lxsp44xhwsd0nhqbp13mwz6ifnl96758h9qy037x";
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
