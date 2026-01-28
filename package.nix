{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.37";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1pi3c2mib0c28xm3n61xpl5262gjggps46wipb6w9j4rhrq324wd";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "02lmy2ypj31kc9x0vjdv3p6dmidj64ppmjiy4i1f70wvkc8gdvbv";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1yc43aqhg0cnpfdjaqgxqgsidicig25gzl9jnwcif3v24irgf4m3";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0iq5z4dyzx01h0j1c7xhsd8gh16zc80cj31ddij6fq6d3xgi6q34";
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
