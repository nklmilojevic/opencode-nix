{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.4.7";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1lcpd614swjlvkvxc4jp9ms8gyj49vrd02i4gg4jxs7vskynd8km";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1q7rxbhngmcf4hlyfb4843nvqx3p2ma52wvqdvll9chxp3m04xgq";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1jgmm3nnf22dylb5gyllxm1xc50xq349k8kr2zm1qq9adgbjv1l6";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1nkc4fb1bp8s2q5zz2jsqqrxjnchf2wzmvsr6psiljvh38wb7146";
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
