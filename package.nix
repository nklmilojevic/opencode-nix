{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.1";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1qpqqlz1kya1crailp1ni6i5aknhhqggbl61xy3477nfyvl0dr2i";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "15dcdpnir2c6jy047p0dihfhrzjg1d6z1j6n1w9p4n0hnnkpwyz5";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "00p1k3400sicawwbx65ddkgv00vx57fpjrncn9qmpml0v07q3zys";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "05s4s0qq2nvhbf54rhfgsx6s33mcv36praji6n1h0hzg8dvqqj1b";
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
