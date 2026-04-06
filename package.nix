{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.17";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "13vi7156rxx7r2sisgs8lpdxcqddxs3hiwdv6gdggiv67klwhxv2";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0zacvvz5ccqkdm1j71vipa2rr2akyjwj1jhxqvnmb3pfrrfnrbvl";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "091xcvpzrf0xs190kh9s3hlrjxr3qljjjaxvj34yvzayczdr8dgf";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "0a8i40qygrsdbjmsb160kry7x14wlas4vvl81xvajj72fn4ajdgz";
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
