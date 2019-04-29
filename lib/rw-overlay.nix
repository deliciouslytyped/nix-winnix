#needs to be a runtime eval
{writeShellScriptBin,
mountprefix, callback, base}:
  writeShellScriptBin "mounter" ''
    set -euo pipefail #http://redsymbol.net/articles/unofficial-bash-strict-mode/
    export SHELLOPTS #Note export exports the key not the value, "updates propagate"
    set -x

    mount="${mountprefix}"
    mkdir -p "$mount" || true #TODO

    pushd "$mount"
    #TODO do i actually need all of these?
    mkdir mutable upper weirdsrc work bind || true #TODO
    #TODO other FS options? is there any way to not need root?
    sudo mount -t overlay weirdsrc -o lowerdir="${base}",upperdir=upper,workdir=work mutable #TODO? , metacopy=on /check other opts
    #these are an adhoc mess figure them out
    sudo chown -R $USER:100 mutable
    sudo chmod -R gu+w mutable
    sudo chmod -R 777 work/work #TODO wat
    popd


    (${callback}/bin/winerunner) #TODO proper

    sudo umount "$mount"/mutable
    set +x
    ''
