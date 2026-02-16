{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.6";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0mwbazmag5nddzrs21jpynhc160nkaxpy6rirsw20z5f09j63swa";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0gzcngjh623kkjjwn03r9axqjclywpy5vmwklywny2akk4s6prlg";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "12gxd3fjgs0wxxlwxqqy8v5a16pxiqml99mm20bi5zlikyq6w13m";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "02c217gh7k4vngm0pp4s67r9md96fd843dn4apgmavy1q5i9k3ig";
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
