{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.14.49";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1izqwj3vql0cziry9bkmvmi6j2jn88rjlcqss6sj3530rzalqyq9";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "0hmzwldsp7jf413prjcqqny63hdxpy4a7yk3r3ym5g6gq8p128p3";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "1nawc82x6mhpv1rfdhy9ccxwampsbf47nlharj346yxijba5gil9";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "1j9p8ln0v2rvcbnvgs2gg4iwbim613py31rhiz3qibb1wyrk78yz";
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
