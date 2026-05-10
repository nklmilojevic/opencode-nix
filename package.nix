{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.46";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0ap68v7hi7va9sh0pa6cfkg9216indzvbwflyzz3f23cq7y93rk5";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "141gl6n6pm1wb0g86hvhj7n6k3nz7smaacfknf2bj5b69jfhcbl5";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "08gdpv2j9i5ka7n3n8620vr08p048q18i18q3jnz1v2vwwy47z3m";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1hyagc8mym6ydj2xv79czr8ppininfkv6lnaz7590lxs6bsilv8b";
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
