{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.18.13";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "0zma90cyga07cwwr8wlivi9886ypbgi0pijicmhnps98g2gsqalx";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0m98q4s18qr5b336d1f270jw5g30fxc9w221lx4zn5pn2hij9r6z";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1pg2awjjhm5xj4xm5zhy02nxac7izyggrpl4badm63cg713lm2p9";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "03gbq3lc968k92df20ql46yn1jf9ds4i9cdv9l068vf562kj3j68";
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
