{fetchurl, stdenv, unzip}:
let
  name = "explorer++";
  exeName = "Explorer++.exe";
  game-data = stdenv.mkDerivation {
    inherit name;
    src = fetchurl {
      url = "https://explorerplusplus.com/software/explorer++_1.3.5_x86.zip";
      sha256 = "1pr2x69vzl8b63gm9739j810rcsc3l1lv5h9c3p8bipw8rqc4njp";
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
      mv -v ./* $out/share/${name}/
      '';
    };
in
  game-data // { inherit name exeName; }
