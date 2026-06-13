{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.6";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0d29blmh3i1891vxq3qz1r3z0hf98qvk0yc0fh8qv9crv04d49j5";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1fb8jppppgqbxi684jf5ffb119gny4ff54yj6h14ahf16sc0lcy8";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0lcr9iymg1qp76gfhanpc82855hxdpai4x3vvcfxnlsb7bz6z7k0";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1b242llwrz22rki6gp6fmqfixp51baacdixmh3pifd8frpxz6ssc";
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
