{fetchurl, stdenv, unzip}:
let
  name = "gta2-installer";
  exeName = "GTA2.exe";
  game-data = stdenv.mkDerivation {
    inherit name;
    src = fetchurl {
      url = "https://gta.com.ua/files/iso/GTA2INSTALLER.ZIP";
      sha256 = "1drsvkqlgbp80vr1bpia72815chs1b4p8s66lv96vkyjyim22j5s";
      };

    #TODO HELLA HACK https://github.com/NixOS/nixpkgs/issues/60157 also dumping all the output into the root dir
    buildInputs = [ unzip ];
    preUnpack = ''
      _myTryUnzip (){
        mkdir myunpack
        mkdir mytemp

        pushd mytemp
        cp "$1" thefile.zip
        popd

        pushd myunpack
        _tryUnzip ../mytemp/thefile.zip #TODO no idea why the fuck this is broken again
        unzip -qq ../mytemp/thefile.zip
        popd

        rm -r mytemp
        }
      unpackCmdHooks=(_myTryUnzip)
      '';

    installPhase = ''
      mkdir -p $out/share/${name}
      pwd
      ls
      mv ./* $out/share/${name}/
      '';
    };
in
  game-data // { inherit name exeName; }
