#!/bin/bash

PYFILE=lc3asm.py

test_single() {
  local e
  NAME="$1"
  [[ "${NAME:${#NAME}-4}" = ".asm" ]] && NAME="${NAME:0:${#NAME}-4}"
  [[ -f "$NAME.o" ]] && rm "$NAME.o"
  python "$PYFILE" "$NAME.asm"
  e=$?
  (( e )) && exit $e
  cmp "$NAME.o" "$NAME.obj"
  e=$?
  (( e )) && exit $e
  echo "=== TEST $NAME PASSED ==="
}

for i in test/*.asm
do
~/Tools/lc3tools/lc3as $i
test_single $i
done