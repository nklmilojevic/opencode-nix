{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.59";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1ghazknm1hwgfn930aj4yscgz99m9b0cddcxfh82r7qyina30nay";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1772jij8ngiha3sr9j4x7c9w8l7rq9hchvn76xssad6v74p90ypr";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "098s7kvmrzpnbwr347z9764xmbrpiglsjq2ixgd1jmkf1dm3pc55";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0c6ym5mhgr7zdpwcxg0z1rzfqb409h5pfpqfqrj321013083m5ra";
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
