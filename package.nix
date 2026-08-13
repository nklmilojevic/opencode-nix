{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.18";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0q4ybz802b47w4sc4lkb9y9xxc6xk65wnag7cf40rfnibp1qzj24";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1mjzrlzxvwwakjr4969cz9zvsggr3miv76wg0saibnxxf1zwqm9l";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "163fq7nrkahdi1ygj729flkp37kc6f98c8kqb1gia4i950v5kars";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "19xlq2qccdaap7m6y2154bslydp1lk79zq0c4ap4yz5jahkgfqlx";
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
