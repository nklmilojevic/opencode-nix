{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.25";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0kc0g82ijcsw7q5hfmzj6w99x3ywzc5jzjf6gn4rpdrzalnc166q";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0wdykirwp2jj8hw39mwq57npp6g00w3vjffp38b40a96zr48ngr7";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0626hha7agn7w6l6v1pj9abi4qf8sh2a1msbq4jy84ys9vg1a9g1";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "018r8hl6zczazy2pwhiblbg4m4vdhqqg146skq38mhflspm83nj3";
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
