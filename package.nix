{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.48";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1lwc80d3nsc8gjfj5gfk6kfdcdrz2iya6wc4wm4z6b37gz7a534h";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "190mp2wl6k00mrcp605yf6i3pfzja584j8igbp7lmbvd70sfsx7k";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "10ys8lic0ylcjhiljb7hqfhm1srx0m0mp8vafqzarykm2jwccdgm";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0zkg929nigbpmzjws21cdgh6jq85cc5n478w0bvybixypfz4z2pg";
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
