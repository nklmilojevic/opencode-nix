{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.14";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1g3wm804lzf8a3m5j4zhn3rdna97h4m5ihsq1vq6kmll8brb9y7s";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "14p9kil8qnh62k18w68dj02gckawb69y9drff0ydpkzrq048cqfj";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0xzwvgnyr2q7y83ibsjqhll97zksd0fi01jz9bhcqhws43snriil";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1zpmh4xz3pjanzqppd4i6rvrzb4nz7q7sy3pm3i8wjbn7rrn9sxc";
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
