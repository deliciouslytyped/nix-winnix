{unzip, stdenv, fetchurl, writeShellScriptBin}:
let
  name = "UniExtract2";
  exeName = "UniExtract.exe";

  game-data = stdenv.mkDerivation rec {
    inherit name;

    src = fetchurl {
      url = "https://github.com/Bioruebe/UniExtract2/releases/download/v2.0.0-rc.2/UniExtractRC2.zip";
      sha256 = "0frry6apsxfja9br3al8f6vbn3y18w6may00yv6vavh5vzr15m2a";
      };

    #TODO HELLA HACK https://github.com/NixOS/nixpkgs/issues/60157 also dumping all the output into the root dir
    buildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out/share/${name}
      mv -v ./* $out/share/${name}/
      '';
    };
in
  game-data // { inherit name exeName; }
