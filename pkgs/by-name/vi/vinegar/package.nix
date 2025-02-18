{ lib
, buildGoModule
, fetchFromGitHub
, wine-staging
, makeBinaryWrapper
, pkg-config
, libGL
, libxkbcommon
, xorg
}:

buildGoModule rec {
  pname = "vinegar";
  version = "1.5.9";

  src = fetchFromGitHub {
    owner = "vinegarhq";
    repo = "vinegar";
    rev = "v${version}";
    hash = "sha256-cLzQnNmQYyAIdTGygk/CNU/mxGgcgoFTg5G/0DNwpz4=";
  };

  vendorHash = "sha256-DZI4APnrldnwOmLZ9ucFBGQDxzPXTIi44eLu74WrSBI=";

  nativeBuildInputs = [ pkg-config makeBinaryWrapper ];
  buildInputs = [ libGL libxkbcommon xorg.libX11 xorg.libXcursor xorg.libXfixes wine-staging ];

  buildPhase = ''
    runHook preBuild
    make PREFIX=$out
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make PREFIX=$out install
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/vinegar \
      --prefix PATH : ${lib.makeBinPath [ wine-staging ]}
  '';

  meta = with lib; {
    description = "An open-source, minimal, configurable, fast bootstrapper for running Roblox on Linux";
    homepage = "https://github.com/vinegarhq/vinegar";
    changelog = "https://github.com/vinegarhq/vinegar/releases/tag/v${version}";
    mainProgram = "vinegar";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ nyanbinary ];
  };
}
