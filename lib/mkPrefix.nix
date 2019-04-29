#TODO make "run wine op" lib function that always calls wineserver -w
#TODO not sure if this is the correct way to get winetricks
{runCommand, wine, xvfb_run, stdenv, winetricks, breakpointHook, bootMode ? "", deskDim ? "1024x768"}:
  stdenv.mkDerivation {
    name = "winePrefix";
    
#    phases = [ "buildPhase" "installPhase" ];
    unpackPhase = "true";

    buildInputs = [ winetricks ];
    buildPhase = ''
      set -x
      mkdir prefix
      #wineboot hack, todo
      # "in theory wineboot -i should just create a wineprefix but I find it safer todo a wine start somenonexistingcommand., wine without GUI access is problemmatic.
      # few things like mountmgr on some system play up when you use a wineboot -i  instead of a normal command."
      #TODO this is not good, fails to write some stuff or something though if home isnt set...
      oldhome="$HOME"
      export HOME="$(mktemp -d)"
      export WINEPREFIX="$(realpath .)"/prefix
      ${ if bootMode == "curses"
         then
           ''"${wine}"/bin/wineconsole --backend=curses cmd /c exit''
         else
           ''"${xvfb_run}"/bin/xvfb-run "${wine}"/bin/wineboot -i''
        }
      # ^ "headless". the wineconsole stuff complained about not being able to access a proper console or something?

      #TODO UGH THIS SECTION IS A TOTAL HACK
      #winetricks vd=1024x768 # "sandbox"? 
      #TODO winetricks vd=1024x768 doesnt work for some reason, when whinetricks doesnt work do as winetricks

      #TODO move to wine lib function
      winetricks #TODO causes some kind of init, otherwise the registry doesnt init..
      #TODO copied from manual result
      cat >> "$WINEPREFIX"/user1.reg <<"EOF"
      [Software\\Wine\\Explorer] 1556497112
      #time=1d4fe2113f27a5c
      "Desktop"="Default"

      [Software\\Wine\\Explorer\\Desktops] 1556497112
      #time=1d4fe2113f27afc
      "Default"="${deskDim}"
      EOF
      cat "$WINEPREFIX"/user1.reg >> "$WINEPREFIX"/user.reg

      export HOME="$oldhome"
      set +x
      '';

    installPhase = ''
      mkdir -p $out
      mv -T prefix $out #TODO ugh mv semantics
      '';
    }
