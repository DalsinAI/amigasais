#!/bin/sh
# The release, for Cradle's stove_build (os32-gcc16-open6, target package):
# the game built by amiga/Makefile.amigaos, then
#   OUT/Parts/<PART>: a GFOpenUp part (GFOpenUpTool INSTALL Parts/<PART>),
#     made by tools/write_part.sh, so the game installs on GFOS;
#   OUT/<NAME>-<VERSION>-68040.lha: the drawer, its icon and the Installer
#     script, with its .sha256 and .readme (tools/pack_dist.py).
# VERSION is the Installer script's $VER, so the archive, the part and the
# Installer always name the same version. package/package.env names the
# drawer (NAME), the make target (TARGET), where it lands (DIST) and the part
# (PART, ABOUT). Nothing is published from here.
# MIT, Copyright (c) 2026 AmiCradle Team.
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$HERE/.." && pwd)
. "$HERE/package.env"
OUT=${OUT:-"$ROOT/build-amiga-package"}
mkdir -p "$OUT"
OUT=$(CDPATH= cd -- "$OUT" && pwd)
cd "$ROOT"
t0=$(date +%s)

sh tests/test_part.sh

# A stove's compiler is in its prefix/ (or STOVE is the prefix itself).
if [ -x "$STOVE/prefix/bin/m68k-amigaos-gcc" ]; then PREFIX="$STOVE/prefix"; else PREFIX="$STOVE"; fi

make -f amiga/Makefile.amigaos STOVE="$STOVE" PREFIX="$PREFIX" -j4 $TARGET > "$OUT/build-output.txt" 2>&1 || { tail -n 60 "$OUT/build-output.txt"; exit 1; }

VERSION=$(sed -n '1s/^; \$VER: [^ ]* \([^ ]*\) (.*/\1/p' amiga/Install-"$NAME")
sh tools/write_part.sh "$DIST" "$NAME" "$OUT/Parts" "$PART" "$VERSION" "$ABOUT"
echo "part: Parts/$PART $VERSION, $(grep -c '^copy' "$OUT/Parts/$PART/Part") files, $(du -sk "$OUT/Parts/$PART" | cut -f1) KB"

python3 "$ROOT/tools/pack_dist.py" --dist "$DIST" --name "$NAME" --out "$OUT"
ls -l "$DIST/$NAME/$NAME"
echo "total: $(( $(date +%s) - t0 )) s"
