{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.16.0";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "034xzg27ynhxqx9kd5srpkzsxbyyrv79bx9bnl92pr1calcyg9hg";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0x43jrlz14wz9q80yl3yj7zigl80cc266pr3ah7kgnxha6vckvak";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0y6cp8pm051pcs0rm6i2hl9qjqys9hazsxsqg7bc1qndamy5x620";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "11kvjs3w2nxy6bqyqsfh25i24wpvx781bkk176hcxc6i906ip7m8";
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
