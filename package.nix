{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.10";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1gdrsnhaa12wx1psn7j1nbqvsli8nl0bjvrqaxmiag52clljsavp";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "05z328r77ap26d2j6dc29d63y064ciman3rrwc4ygb1w6cvsldwd";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0v9x4g0zyhq3v3xkgx6yj4zxdkk6mamv8cdw09qaalnfwablbah1";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1xchqvb1qcnmg8c23j2z56f28cdprmaq3w6fbkyhwahkm3cqy6sc";
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
