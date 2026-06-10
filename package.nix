{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.1";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0ikqajk80xbx634v9v75rspn1axhm5zg9dycby4y5kk9jnhslmj8";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0v6q78ssk1j8lffzd9bzym78cy9hbcsa193bp1vsghvyzi54c9la";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1gxhsadgmicc712yrbwfcgbyjjjz656i254f7q52g8yg8208qc3r";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0rxlh49qaj1gvjwi2f1qjvr6fqjwhzbz7aaq2bnq58iq824fzwgk";
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
