{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  version = "1.3.3";

  platformInfo = {
    "x86_64-linux" = {
      platform = "linux-x64";
      sha256 = "1bl945cqn0ns1912bpcz0lbcra6cw4iffnhy9nssln5wr2990i3g";
    };
    "aarch64-linux" = {
      platform = "linux-arm64";
      sha256 = "1zdzx41lbbww29y9lcr5nhwjd9c1l875r4jnphjkl859wk364caf";
    };
    "x86_64-darwin" = {
      platform = "darwin-x64";
      sha256 = "0cpf7znzwfhir0d6vkihffyshzqv40y5phlp2qmdcaignghddkyy";
    };
    "aarch64-darwin" = {
      platform = "darwin-arm64";
      sha256 = "10km4kmivh10gk15analbzqfi7gki9m900api0npc2ryriwl45fy";
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
