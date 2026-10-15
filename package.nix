{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.19.1";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0d57hwwfx8phy62h0kkl2vz7hc62qk7fm41cbybvs27crzxg5qkf";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1s3j3id7pzp8wnpm42d6pry62kyfib83cs2crj5lkcj4rrj7iknr";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "06m96vpn7c9hh2y6ixxkzbm3353vf3jsqd0qyr60rc7dd5jz6v8j";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "13r82vy7sjyfzpb93h2mw623kx8h38pfj03badwjmlrbddpj68vz";
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

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
