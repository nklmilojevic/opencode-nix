{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.1.33";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "16aaf1g0ma2fdag0na89kl6rw88xcr8am6fjkf8yj97lg51lcj4y";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0nd7ck4a2m6a61ngcwn0w2wv7894z3g9wxc8gvkgxqwbq4d5kb8j";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1d1cw2ycdcvl4ma7341vka9n5ghmsrc90q7hgnhjr75gb1naa579";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "181mknwcjlfld9hjhmvr0cpnxn52agy6zl2zk7kd7z0j6fifz3qc";
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
