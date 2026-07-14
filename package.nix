{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.1";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1az8kgp8a2d20k54maqj7kxh18rf17v836npkpb2hk80ymylqkk9";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "07ngh274ibbclkj6ndql79gkh1y57zi427jxikvh9rzjavmmg09y";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0b1nlravgh71v4nilkg7jyfwxwxm7nk1xip1q4rwgzykqmk9h8qx";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "17ypaq9i2yzl3qs0p4lyda7lzhdxypvyxamyi9qq75bv18x4c4ba";
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
