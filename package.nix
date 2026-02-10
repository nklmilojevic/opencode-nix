{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.55";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "00alp7555sk3gxxh1bjjri1q2i5zr1nwv2nydh44di5mq621k61r";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1d4js8wz02wk3d19hhhra8597b5miq1ywbmx1cr23zl1wsxqfkiw";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0f102rax5gaaz7zmzlb8a0z14z4vhcznjdhas05nig64gb4x16mq";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1i6xs7ayd20af6dxpj627v420rmfp0078hfnjdsg1pnm0sj93wmm";
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
