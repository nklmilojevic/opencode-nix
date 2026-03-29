{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.6";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0sg1v35lc69ayh743m8rn52b2sbh8szbas6qc5sqdpnm0lcfvi2q";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1gb9vqmkv5bj7zrkaabw4g7xxrdwzkss6d2lbxlh10vgy0wdh2p9";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1lq0yd4ii5jy705dibcnw82hq4nk2fqyqn129v1a78ph0f4aw3kl";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1fsgmf3xarv1945gjjnw1pqvik03h872a3kng8way4piav9x14hz";
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
