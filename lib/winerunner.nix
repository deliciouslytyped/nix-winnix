# References
# https://www.gnu.org/software/bash/manual/html_node/Redirections.html

# prefix ~ base in the other file
{lsof, lib, writeShellScriptBin, mountprefix, wine, game-data, prefix, wineDebug ? false, tee ? false, deskDim ? "1024x768" }:
  writeShellScriptBin "winerunner" ''
    set -euo pipefail #http://redsymbol.net/articles/unofficial-bash-strict-mode/
    newXephyr (){
      newDisplayIndex=2
      Xephyr :$newDisplayIndex -screen ${deskDim} &> "${mountprefix}"/xephyr-$newDisplayIndex-log &
      xeph_pid=$! #TODO unreliable PID method
      export DISPLAY=:$newDisplayIndex
      }

    newXephyr
    env ${lib.optionalString (wineDebug != false) "WINEDEBUG=${wineDebug}"} \
      WINEPREFIX="${mountprefix}"/mutable "${wine}/bin/wine" \
        "${game-data}/share/${game-data.name}/${game-data.exeName}" \
        "$@" \
        ${if tee then "|& tee" else "&>"} "${mountprefix}"/wine-log \
        || true
    #TODO need to wait till wineserver and everything stops
    WINEPREFIX="${mountprefix}"/mutable "${wine}/bin/wineserver" -w ${if tee then "|& tee -a" else "&>>"} "${mountprefix}"/wine-log || true #TODO
    kill -9 $xeph_pid || true #TODO
    ''
