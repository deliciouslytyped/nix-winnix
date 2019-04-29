{fetchurl, stdenv, unzip}:
let
  name = "gta2";
  exeName = "";
  game-data = stdenv.mkDerivation {
    inherit name;
    src = null;

    };
in
  game-data // { inherit name exeName; }
