{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.32";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0rlsx8swpi3liknrbzlxqky8pdsymmfxsq8r2xqnqkkl4b4wy6c5";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0f6dvx7j1a77gxnsbvkydwv767x84jk8w8rq8w9fngj4rfy37j7d";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1lmgrbrpbdg92ncdmafgw7bhlh8nj5df9ph49b75iyi8yv1rskyb";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1l9564cmbig5h5p84bsmwm509xaabcjv3mbxfw8455yanlyngy5p";
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
