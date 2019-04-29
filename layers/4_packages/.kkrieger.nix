{fetchzip, stdenv}:
let
  name = "dot-kkrieger";
  exeName = "pno0001.exe";
  game-data = stdenv.mkDerivation {
    inherit name;
    src = fetchzip {
      url = "https://files.scene.org/get/parties/2004/breakpoint04/96kgame/kkrieger-beta.zip";
      sha256 = "07kqnsrpai232m1j6jlc9acwwyp0knd0m2kd2pyqanwwidmhdksk";
      stripRoot = false; #TODO check this is correct
      };

    installPhase = ''
      mkdir -p $out/share/${name}
      mv -v ./* $out/share/${name}/
      '';
    };
in
  game-data // { inherit name exeName; }

