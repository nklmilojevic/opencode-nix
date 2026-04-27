{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.28";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0b094vrjij43qjj4hpx4acz112v9phf82lxxdibm9nn7s7kkrahv";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1rlpzcanq46mdjgbbgjkb8j3rxrdc5wrmm6dh88vzjvg61lvv0a7";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0ad4sg46qbmg70ays3b9a4zwx3ycpmx2c3yi4z4hnnj64d0flid0";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1nv9hmkhbg45f4acwz9d097ln2dhxggv2zkhz1dwhis5cnj91bwh";
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
