{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.35";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0cv147r1a9qpzcfpbnbldrj86vbncba217w4d9ldj900bmyrkj75";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1fl42kra3pnqngkanaxkplw7y9prksrnsxj376fwf9vrxb7nxzap";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1nzz4c9gpi7xc3gh0gydyijp1lc2m1ksl22j7dz6hvxizh97nbds";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1czfn3b9yp1zc6lbayilyx6bqbgkyr2l1hjnjyjxgjr78hzm89mn";
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
