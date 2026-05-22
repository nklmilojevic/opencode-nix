{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.15.8";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1yfkajpz68l779qwy02nyx24v0a7q21f85nj4q9p13yd038ac44j";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0yyv68aff1r2qsgwsa7zvrrqjg5lbsfca87q9hpwnngs0p4hvxyq";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "172nfk0pfqxrliivm6z9rh55gprk522ycks2jjgph92q38nd13px";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1432rwffpx1d72v9gbx0ccxaq2vjf3w69kwbl2zrwaqzaclqcss9";
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
