{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.17.19";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "00i6v4vnr0z8byyvz9sh70n4z4xv4wra3lfhibh6k4wicajffyi8";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1xa5ig8c781qj7dxkw9qwy4z96w5dn222h5q7g2pdgpgfazymg1y";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "117d3pzxah1clzablpn4ywsfllydm3dgwk9qiiq25y217b3qwwlj";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0fsvgdmf1098lwp1gz8ak630yjwn0952c5igk9crdgxsvdkhfpk9";
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
