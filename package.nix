{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.5";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1fjmaciynvak2j24a51qdn27sn9ivvdqiwdk282rf09gd75lxw9l";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0yql9416nkgr59qdjx9nrhz4w7mbvbfb4fq0i57xccd8q7627d80";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "16h8s1jamppjcg822895skbfk1r6szm0kzny5212phkrlsvy3z74";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0brn2jifqy53xnda3mwaayqd7da36m0r4rxqqwk6di1xs9krzv8j";
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
