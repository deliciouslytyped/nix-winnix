#needs to be a runtime eval
{writeShellScriptBin, fuse-overlayfs,
mountprefix, callback, base}:
  writeShellScriptBin "mounter" ''
    set -euo pipefail #http://redsymbol.net/articles/unofficial-bash-strict-mode/
    export SHELLOPTS #Note export exports the key not the value, "updates propagate"
    set -x

    mount="${mountprefix}"
    gio trash "$mount" || true
    mkdir -p "$mount" || true #TODO

    pushd "$mount"
    #TODO do i actually need all of these?
    mkdir mutable upper work bind || true #TODO

    cp -r "${base}" lower
    chmod -R gu+w lower
    # map root’s uid/gid to user’s and the rest as is
    ${fuse-overlayfs}/bin/fuse-overlayfs -o uidmapping=0:$(id -u):1:1:1:65536,gidmapping=0:$(id -g):1:1:1:65536,lowerdir=lower,upperdir=upper,workdir=work mutable #TODO? , metacopy=on /check other opts
    popd


    (${callback}/bin/winerunner) #TODO proper

    fusermount -u "$mount"/mutable
    set +x
    ''
