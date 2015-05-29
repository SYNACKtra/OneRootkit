#!/bin/bash

cd `dirname $0`

for srcfile in src/*.c
do
	BIN_LOC=`echo "$srcfile" | sed 's/\\.c//'|sed 's/src/bin/'`
	gcc $srcfile -o "$BIN_LOC" && echo "[TESTS] Compiled $BIN_LOC"
done

echo "[TEST] Finished compiling"
