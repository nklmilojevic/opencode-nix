{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.2.22";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0qmrmhp116qvghd1vhi343wdswjsm5dycbcw5k9dc3y0pfgwn27k";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0bmj162v0n191glhz1wscvk2l1blx255qf2435n648izdkr7ynjc";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "17qp93hjw3hnwp9z4q96hkxkrm54as23a59dy5jgg4sq1897z42h";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0hqn5nbmd93kdx4hwji59d2xlzf55rmw6dizwm7i7dqn8239sh9a";
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
