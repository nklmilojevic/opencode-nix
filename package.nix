{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.20";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0xlx05bbkdhnnr1s7lk5hkxnhkcwma61gskgaaaa9nvzm12vvrmz";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "06ddjhlfh1ip5g9i92vz55fqf3g74ff32355lyhbvqk14j715bfc";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1h1vjxp9xv2ysvhz6nx0q2ynjd6wxvwbg2hzgwflcl2n655p0frh";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1rhmqw2pxbkq0bf8fq7vmqalhrainlj99i3jgr3qc75hlx6qzcsk";
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
