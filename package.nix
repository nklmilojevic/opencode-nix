{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.22";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0pwmppksy1dqlwzxwmwcmsjn75h06s3mlbax7s1d2jjalpjv1pmj";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0ssgkzpp3hc2kdi61gzcwy0zsak13zahg2nqk4kwbb5yf5830d48";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0781fi873fc97hn6m0bs2phwkcqlmvf2yy2j478kmkx519r1rbgx";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "15vn926vv1m5f599vmdcc5lmjm6vz60rl9pj8khyfgjqlqcl1kjw";
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
