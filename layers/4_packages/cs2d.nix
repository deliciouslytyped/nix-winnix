{unzip, stdenv, fetchurl, writeShellScriptBin}:
let
  name = "cs2d";
  exeName = "Launcher.exe";

  game-data = stdenv.mkDerivation rec {
    inherit name;

    src = fetchurl {
      name = "cs2d.zip";
      url = "https://www.unrealsoftware.de/get.php?get=cs2d_1008_win.zip&p=1&cid=1619";
      sha256 = "1g66635m8zfsxdmg95c1xz72s6pam9w1myrjwk4dnw697dhpir1p";
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
        _tryUnzip ../mytemp/thefile.zip
        popd

        rm -r mytemp
        }
      unpackCmdHooks=(_myTryUnzip)
      '';

    installPhase = ''
      mkdir -p $out/share/${name}
      mv -v ./* $out/share/${name}/
      '';
    };
in
  game-data // { inherit name exeName; }
