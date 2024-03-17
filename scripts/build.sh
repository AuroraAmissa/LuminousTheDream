#!/bin/sh

cd "$(realpath "$(dirname "$0")")/.." || exit 1

if [ "$#" -ne 1 ]; then
    TARGET="draft"
else
    TARGET="$1"
fi

NIXFLAGS=""
if [ "$TARGET" != "ci" ]; then
    NIXFLAGS="--log-format bar-with-logs"
fi

nix run $NIXFLAGS .?submodules=1#build_"$TARGET"
