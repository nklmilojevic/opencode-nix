{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.13";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1b358lwgsjpc8j2qdvs9iv7fvkf9k51rdwqy0vh5xnlylrl0h4yp";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1y9i1by85ydcqrfwnl8caiajgdgipwhp1lnvsq48mg1bs8kfcxy9";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1l0sbk26ld0cdahk6bdz2wj82r75h7awpy1xqjn6b2gzl064ppfd";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1yzfz79p4r1q1xrn2qk1xjkil0k70vr11fj7ihmrc71qbdlab3sj";
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
