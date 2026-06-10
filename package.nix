{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.0";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0561zyp35w61vn6r81kgjja211636p98d9nlrnyq5qy9j7kn6lmd";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0bfcgdylqd14m879b06yg237in8f9c6i7yqxra6rfs8ab9f74h94";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0kc7rwgv3nlfkrfb1r06fxrb9v56k9ic8033q3xainfiy4pk7ppm";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1v7z4i0m5r8wx8i18a7xfz9qk3gqr4fakb2sb8qv3lcb2qdzqvjg";
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
