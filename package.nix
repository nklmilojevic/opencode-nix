{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.19";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1sxwb38naxcfadhkd68j4j5zbwvarjxkfl5axk0vjxs6kzibyjqz";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0a6jrmzyfr8076wb18p1majckq2lwmjrv5ibacmwy48jpjwdd6f0";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "00bqy59jf5x7s2a3szinhxcmjpr6qsfx38kfnpvcrj1k0aib9vv8";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0vjrw5iqnfk0afn6zb11hafdxn77bpnmi30rrvc89n2ls6357w7i";
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
